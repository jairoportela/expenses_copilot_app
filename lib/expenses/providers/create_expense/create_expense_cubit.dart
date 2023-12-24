import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/expenses/data/repository/expenses_repository.dart';

import 'package:form_inputs/form_inputs.dart';
import 'package:query_repository/query_repository.dart';

part 'create_expense_state.dart';

class CreateExpenseCubit extends Cubit<CreateExpenseState> {
  CreateExpenseCubit(
      {required ExpensesRepository repository, required String userId})
      : _repository = repository,
        _userId = userId,
        super(CreateExpenseState.empty);
  final ExpensesRepository _repository;
  final String _userId;

  void onChangeCategory(String? value) => emit(state.copyWith(
          categoryId: TextInputValue.validated(
        value ?? '',
      )));

  void onChangeDate(DateTime? value) => emit(state.copyWith(date: value));

  void onChangePaymentMethod(String? value) => emit(state.copyWith(
          paymentMethodId: TextInputValue.validated(
        value ?? '',
      )));

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

  void onSubmit() async {
    try {
      final finalState = state.copyWith(
        categoryId: TextInputValue.validated(state.categoryId.value),
        paymentMethodId: TextInputValue.validated(state.paymentMethodId.value),
        value: NumberInputValue.validated(state.value.value),
        name: TextInputValue.validated(state.name.value),
        date: state.date,
      );
      emit(finalState);

      if (finalState.isNotValid) return;

      emit(state.copyWith(status: const FormSubmitLoading()));
      await _repository.create(data: state.toJson(), userId: _userId);
      emit(state.copyWith(status: const FormSubmitSuccess()));
    } on CreateError catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.message)));
    } catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.toString())));
    }
  }
}
