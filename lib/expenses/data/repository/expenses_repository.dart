import 'package:expenses_copilot_app/expenses/data/models/expense.dart';
import 'package:crud_repository/crud_repository.dart';

abstract class ExpensesRepository {
  Future<bool> create({required String userId, required Expense data});
  Future<bool> edit({
    required String id,
    required String userId,
    required Expense data,
  });

  Stream<List<Expense>> getAll();
}

class ExpensesRepositoryImplementation extends ExpensesRepository {
  ExpensesRepositoryImplementation({required CrudRepository dataSource})
      : _dataSource = dataSource;
  final CrudRepository _dataSource;

  static const _tableName = 'expenses';

  @override
  Future<bool> create({required String userId, required Expense data}) {
    return _dataSource.create(
      createHelper: CreateHelper(
          tableName: _tableName, data: {...data.toJson(), 'user_id': userId}),
    );
  }

  @override
  Future<bool> edit(
      {required String userId, required Expense data, required String id}) {
    return _dataSource.edit(
      editHelper: EditHelper(
        tableName: _tableName,
        data: {...data.toJson(), 'user_id': userId},
        columnName: 'id',
        value: id,
      ),
    );
  }

  @override
  Stream<List<Expense>> getAll() {
    return _dataSource
        .subscribe(
      subscribeHelper:
          const SubscribeHelper(tableName: _tableName, primaryKey: ['id']),
    )
        .asyncMap((event) async {
      final data = await _dataSource.getAll(
        queryHelper: const QueryHelper(
          tableName: _tableName,
          selectString:
              '''*,categories(id,name,icon),payment_methods(id,name,icon)''',
          fromJson: Expense.fromJson,
          orderFilter: [
            OrderFilter(
              ascending: false,
              columnName: 'date',
            )
          ],
        ),
      );
      return data;
    });
  }
}
