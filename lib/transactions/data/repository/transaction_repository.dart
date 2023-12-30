import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/expenses/data/models/expense.dart';
import 'package:expenses_copilot_app/incomes/data/models/income.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:query_repository/query_repository.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> getAll(
    CategoryType? type,
  );
  Stream<List<Transaction>> getRecents();

  Future<Transaction> getOne({
    required CategoryType categoryType,
    required String id,
  });
}

class TransactionRepositoryImplementation extends TransactionRepository {
  TransactionRepositoryImplementation({required QueryRepository dataSource})
      : _dataSource = dataSource;
  final QueryRepository _dataSource;

  static const _tableName = 'transactions';

  @override
  Stream<List<Transaction>> getAll(
    CategoryType? type,
  ) {
    return _dataSource
        .subscribe(
          subscribeHelper: const SubscribeHelper(
              tableName: _tableName, primaryKey: ['id', 'type']),
        )
        .order('date', ascending: false)
        .asyncMap((event) async {
      final data = await _dataSource.getAll(
        queryHelper: QueryHelper(
          tableName: _tableName,
          selectString: '''*,categories(id,name,icon)''',
          fromJson: Transaction.fromJson,
          inFilter: InFilter(
            columnName: 'id',
            dataToFilter: event.map((e) => (e['id'] as String?) ?? '').toList(),
          ),
          filter: type != null ? {'type': type.name} : null,
          orderFilter: [
            const OrderFilter(
              ascending: false,
              columnName: 'date',
            ),
            const OrderFilter(
              ascending: false,
              columnName: 'created_at',
            )
          ],
        ),
      );
      return data;
    });
  }

  @override
  Stream<List<Transaction>> getRecents() {
    return _dataSource
        .subscribe(
          subscribeHelper: const SubscribeHelper(
              tableName: _tableName, primaryKey: ['id', 'type']),
        )
        .limit(20)
        .order('date', ascending: false)
        .asyncMap((event) async {
      final data = await _dataSource.getAll(
        queryHelper: QueryHelper(
          tableName: _tableName,
          selectString: '''*,categories(id,name,icon)''',
          fromJson: Transaction.fromJson,
          inFilter: InFilter(
            columnName: 'id',
            dataToFilter: event.map((e) => (e['id'] as String?) ?? '').toList(),
          ),
          orderFilter: [
            const OrderFilter(
              ascending: false,
              columnName: 'date',
            ),
            const OrderFilter(
              ascending: false,
              columnName: 'created_at',
            )
          ],
        ),
      );
      return data;
    });
  }

  @override
  Future<Transaction> getOne(
      {required CategoryType categoryType, required String id}) async {
    return await switch (categoryType) {
      CategoryType.expense => _dataSource.getOne<Expense>(
          queryHelper: QueryHelper(
              tableName: 'expenses',
              selectString:
                  '''*,categories(id,name,icon),payment_methods(id,name,icon)''',
              fromJson: Expense.fromJson,
              filter: {'id': id}),
        ),
      CategoryType.income => _dataSource.getOne<Income>(
          queryHelper: QueryHelper(
            tableName: 'incomes',
            selectString: '''*,categories(id,name,icon)''',
            fromJson: Income.fromJson,
            filter: {'id': id},
          ),
        ),
    };
  }
}
