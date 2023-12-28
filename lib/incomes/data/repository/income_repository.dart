import 'package:expenses_copilot_app/incomes/data/models/income.dart';
import 'package:query_repository/query_repository.dart';

abstract class IncomeRepository {
  Future<bool> create({required String userId, required Income data});
}

class IncomeRepositoryImplementation extends IncomeRepository {
  IncomeRepositoryImplementation({required QueryRepository dataSource})
      : _dataSource = dataSource;
  final QueryRepository _dataSource;

  static const _tableName = 'incomes';

  @override
  Future<bool> create({required String userId, required Income data}) {
    return _dataSource.create(
      createHelper: CreateHelper(
          tableName: _tableName, data: {...data.toJson(), 'user_id': userId}),
    );
  }
}
