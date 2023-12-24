import 'package:expenses_copilot_app/expenses/data/models/expense.dart';
import 'package:query_repository/query_repository.dart';

abstract class ExpensesRepository {
  Future<bool> create(
      {required String userId, required Map<String, dynamic> data});

  Stream<List<Expense>> getAll();
}

class ExpensesRepositoryImplementation extends ExpensesRepository {
  ExpensesRepositoryImplementation({required QueryRepository dataSource})
      : _dataSource = dataSource;
  final QueryRepository _dataSource;

  static const _tableName = 'expenses';

  @override
  Future<bool> create(
      {required String userId, required Map<String, dynamic> data}) {
    return _dataSource.create(
      createHelper: CreateHelper(
          tableName: _tableName, data: {...data, 'user_id': userId}),
    );
  }

  @override
  Stream<List<Expense>> getAll() {
    return _dataSource
        .subscribe(
      subscribeHelper:
          const SubscribeHelper(tableName: _tableName, primaryKey: 'id'),
    )
        .asyncMap((event) async {
      final data = await _dataSource.getAll(
          queryHelper: const QueryHelper(
              tableName: _tableName,
              selectString:
                  '''*,expenses_categories(id,name),payment_methods(id,name)''',
              fromJson: Expense.fromJson));
      return data;
    });
  }
}