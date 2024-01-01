import 'package:expenses_copilot_app/categories/data/models/models.dart';
import 'package:crud_repository/crud_repository.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll({required CategoryType type});
  Future<bool> createAll({
    required List<Category> categories,
    required String userId,
  });
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

  @override
  Future<bool> createAll(
      {required List<Category> categories, required String userId}) async {
    final data = await _dataSource.createMany(
      createHelper: CreateManyHelper(
        tableName: _tableName,
        data:
            categories.map((e) => {...e.toJson(), 'user_id': userId}).toList(),
      ),
    );
    return data;
  }
}
