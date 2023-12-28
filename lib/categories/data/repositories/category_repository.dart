import 'package:expenses_copilot_app/categories/data/models/models.dart';
import 'package:query_repository/query_repository.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll({required CategoryType type});
}

class CategoryRepositoryImplementation extends CategoryRepository {
  CategoryRepositoryImplementation({required QueryRepository dataSource})
      : _dataSource = dataSource;
  final QueryRepository _dataSource;

  static const _tableName = 'categories';

  @override
  Future<List<Category>> getAll({required CategoryType type}) async {
    final data = await _dataSource.getAll<Category>(
      queryHelper: QueryHelper(
          tableName: _tableName,
          selectString: '*',
          fromJson: Category.fromJson,
          orderFilter: const OrderFilter(ascending: true, columnName: 'name'),
          filter: {
            'type': type.name,
          }),
    );
    return data;
  }
}
