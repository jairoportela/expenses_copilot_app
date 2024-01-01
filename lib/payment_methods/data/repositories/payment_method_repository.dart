import 'package:crud_repository/crud_repository.dart';
import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethod>> getAll();

  Future<bool> createAll({
    required List<PaymentMethod> paymentMethods,
    required String userId,
  });
}

class PaymentMethodRepositoryImplementation extends PaymentMethodRepository {
  PaymentMethodRepositoryImplementation({required CrudRepository dataSource})
      : _dataSource = dataSource;
  final CrudRepository _dataSource;

  static const _tableName = 'payment_methods';

  @override
  Future<List<PaymentMethod>> getAll() async {
    final data = await _dataSource.getAll<PaymentMethod>(
      queryHelper: const QueryHelper(
        tableName: _tableName,
        selectString: '*',
        fromJson: PaymentMethod.fromJson,
        orderFilter: [OrderFilter(ascending: true, columnName: 'name')],
      ),
    );
    return data;
  }

  @override
  Future<bool> createAll(
      {required List<PaymentMethod> paymentMethods,
      required String userId}) async {
    final data = await _dataSource.createMany(
      createHelper: CreateManyHelper(
        tableName: _tableName,
        data: paymentMethods
            .map((e) => {...e.toJson(), 'user_id': userId})
            .toList(),
      ),
    );
    return data;
  }
}
