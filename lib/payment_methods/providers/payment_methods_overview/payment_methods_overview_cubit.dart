import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';
import 'package:crud_repository/crud_repository.dart';

part 'payment_methods_overview_state.dart';

class PaymentMethodsOverviewCubit extends Cubit<PaymentMethodsOverviewState> {
  PaymentMethodsOverviewCubit({required CrudRepository repository})
      : _repository = repository,
        super(PaymentMethodsOverviewInitial());
  final CrudRepository _repository;

  void getData() async {
    try {
      emit(PaymentMethodsOverviewLoading());
      final data = await _repository.getAll<PaymentMethod>(
        queryHelper: const QueryHelper(
          tableName: 'payment_methods',
          selectString: '*',
          fromJson: PaymentMethod.fromJson,
          orderFilter: [OrderFilter(ascending: true, columnName: 'name')],
        ),
      );
      emit(PaymentMethodsOverviewSuccess(data));
    } catch (error) {
      emit(PaymentMethodsOverviewError());
    }
  }
}
