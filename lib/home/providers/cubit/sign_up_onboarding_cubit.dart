import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/categories/data/models/models.dart';
import 'package:expenses_copilot_app/categories/data/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';

part 'sign_up_onboarding_state.dart';

class SignUpOnboardingCubit extends Cubit<SignUpOnboardingState> {
  SignUpOnboardingCubit({
    required CategoryRepository repository,
    required AuthenticationRepository authenticationRepository,
  })  : _repository = repository,
        _authRepository = authenticationRepository,
        super(SignUpOnboardingState.empty);

  void onExpenseCategoryChange(String id, CategorySelectableItem category) {
    final data = {...state.expensesCategories};
    if (data.containsKey(id)) {
      data.remove(id);
    } else {
      data[id] = category;
    }
    emit(state.copyWith(
      expensesCategories: data,
      stepError: () => null,
    ));
  }

  void onIncomeCategoryChange(String id, CategorySelectableItem category) {
    final data = {...state.incomesCategories};
    if (data.containsKey(id)) {
      data.remove(id);
    } else {
      data[id] = category;
    }
    emit(state.copyWith(
      incomesCategories: data,
      stepError: () => null,
    ));
  }

  void incomesCategoriesStepChanged() {
    emit(state.copyWith(
      stepError: () => null,
    ));

    if (state.expensesCategories.isEmpty) {
      emit(state.copyWith(
        stepError: () => 'Selecciona al menos una categoría.',
      ));
      return;
    }

    emit(state.copyWith(
      step: SignUpOnboardingStep.selectIncomesCategories,
      stepError: () => null,
    ));
  }

  void goBackToExpenses() {
    emit(state.copyWith(
      step: SignUpOnboardingStep.selectExpensesCategories,
    ));
    return;
  }

  submitFinishOnboarding(String userId) async {
    emit(state.copyWith(
      stepError: () => null,
    ));

    if (state.expensesCategories.isEmpty && state.incomesCategories.isEmpty) {
      state.copyWith(
        stepError: () => 'Selecciona al menos una categoría.',
      );
      return;
    }

    try {
      emit(state.copyWith(status: const FormSubmitLoading()));
      await _repository.createAll(categories: [
        ...state.expensesCategories.values.map(
          (e) => Category(
            id: '',
            name: e.name,
            icon: e.icon.codePoint,
            type: CategoryType.expense,
          ),
        ),
        ...state.incomesCategories.values.map(
          (e) => Category(
            id: '',
            name: e.name,
            icon: e.icon.codePoint,
            type: CategoryType.income,
          ),
        )
      ], userId: userId);
      await _authRepository.updateMetadataUser(data: {
        'finish_onboarding': true,
      });
      emit(state.copyWith(status: const FormSubmitSuccess()));
    } catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.toString())));
    }
  }

  final CategoryRepository _repository;
  final AuthenticationRepository _authRepository;
}