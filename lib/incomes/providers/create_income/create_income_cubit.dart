import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/categories/data/models/category.dart';
import 'package:expenses_copilot_app/incomes/data/models/income.dart';
import 'package:expenses_copilot_app/incomes/data/repository/income_repository.dart';
import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:expenses_copilot_app/utils/number_format.dart';

import 'package:form_inputs/form_inputs.dart';
import 'package:crud_repository/crud_repository.dart';

part 'create_income_state.dart';

class CreateIncomeCubit extends Cubit<CreateIncomeState> {
  CreateIncomeCubit({
    required IncomeRepository repository,
    required String userId,
    Income? income,
  })  : _editingExpenseId = income?.id,
        _repository = repository,
        _userId = userId,
        super(
          income == null
              ? CreateIncomeState.empty
              : CreateIncomeState.fromIncome(income),
        );
  final IncomeRepository _repository;
  final String _userId;
  final String? _editingExpenseId;

  void onChangeCategory(String? value) => emit(state.copyWith(
          categoryId: TextInputValue.validated(
        value ?? '',
      )));

  void onChangeDate(DateTime? value) => emit(state.copyWith(date: value));

  void onChangeName(String value) {
    final previousValue = state.name;
    final shouldValidate = previousValue.isPure;
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
    final shouldValidate = previousValue.isPure;
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
        value: NumberInputValue.validated(state.value.value),
        name: TextInputValue.validated(state.name.value),
        date: state.date,
      );
      emit(finalState);

      if (finalState.isNotValid) return;

      emit(state.copyWith(status: const FormSubmitLoading()));
      await _repository.create(data: state.toIncome(), userId: _userId);
      emit(state.copyWith(status: const FormSubmitSuccess()));
    } on CreateError catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.message)));
    } catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.toString())));
    }
  }

  void onEditingSubmit() async {
    try {
      final finalState = state.copyWith(
        categoryId: TextInputValue.validated(state.categoryId.value),
        value: NumberInputValue.validated(state.value.value),
        name: TextInputValue.validated(state.name.value),
        date: state.date,
      );
      emit(finalState);

      if (finalState.isNotValid) return;

      emit(state.copyWith(status: const FormSubmitLoading()));
      await _repository.edit(
        data: state.toIncome(_editingExpenseId),
        userId: _userId,
      );
      emit(state.copyWith(status: const FormSubmitSuccess()));
    } on CreateError catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.message)));
    } catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.toString())));
    }
  }
}
