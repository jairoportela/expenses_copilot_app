import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

part 'create_expense_state.dart';

class CreateExpenseCubit extends Cubit<CreateExpenseState> {
  CreateExpenseCubit() : super(CreateExpenseState.empty);

  void onChangeCategory(String? value) =>
      emit(state.copyWith(categoryId: value));

  void onChangeDate(DateTime? value) => emit(state.copyWith(date: value));

  void onChangePaymentMethod(String? value) =>
      emit(state.copyWith(paymentMethodId: value));

  void onChangeName(String value) {
    final previousValue = state.name;
    final shouldValidate = previousValue.isNotValid;
    final newState = state.copyWith(
      name: shouldValidate
          ? TextInputValue.unvalidated(
              value,
            )
          : TextInputValue.validated(
              value,
            ),
    );
    emit(newState);
  }

  void onChangeValue(String value) {
    final previousValue = state.value;
    final shouldValidate = previousValue.isNotValid;
    final newState = state.copyWith(
      value: shouldValidate
          ? NumberInputValue.unvalidated(
              value,
            )
          : NumberInputValue.validated(
              value,
            ),
    );
    emit(newState);
  }
}
