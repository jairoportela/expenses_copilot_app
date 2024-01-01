import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';
import 'package:expenses_copilot_app/payment_methods/data/repositories/payment_method_repository.dart';

part 'payment_methods_overview_state.dart';

class PaymentMethodsOverviewCubit extends Cubit<PaymentMethodsOverviewState> {
  PaymentMethodsOverviewCubit({
    required PaymentMethodRepository repository,
  })  : _repository = repository,
        super(PaymentMethodsOverviewInitial());
  final PaymentMethodRepository _repository;

  void getData() async {
    try {
      emit(PaymentMethodsOverviewLoading());
      final data = await _repository.getAll();
      emit(PaymentMethodsOverviewSuccess(data));
    } catch (error) {
      emit(PaymentMethodsOverviewError());
    }
  }
}
