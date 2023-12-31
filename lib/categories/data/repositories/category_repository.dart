import 'package:expenses_copilot_app/categories/data/models/models.dart';
import 'package:crud_repository/crud_repository.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll({required CategoryType type});
}

class CategoryRepositoryImplementation extends CategoryRepository {
  CategoryRepositoryImplementation({required CrudRepository dataSource})
      : _dataSource = dataSource;
  final CrudRepository _dataSource;

  static const _tableName = 'categories';

  @override
  Future<List<Category>> getAll({required CategoryType type}) async {
    final data = await _dataSource.getAll<Category>(
      queryHelper: QueryHelper(
          tableName: _tableName,
          selectString: '*',
          fromJson: Category.fromJson,
          orderFilter: [
            const OrderFilter(ascending: true, columnName: 'name')
          ],
          filter: {
            'type': type.name,
          }),
    );
    return data;
  }
}
