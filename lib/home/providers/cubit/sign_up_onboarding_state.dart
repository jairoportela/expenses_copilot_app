part of 'sign_up_onboarding_cubit.dart';

class CategorySelectableItem {
  const CategorySelectableItem(
    this.id,
    this.name,
    this.icon,
  );
  final String id;
  final String name;
  final IconData icon;
}

enum SignUpOnboardingStep {
  selectExpensesCategories,
  selectIncomesCategories,
  addPhotoProfile,
}

class SignUpOnboardingState extends Equatable {
  const SignUpOnboardingState({
    required this.expensesCategories,
    required this.incomesCategories,
    required this.step,
    required this.status,
    this.stepError,
  });

  final Map<String, CategorySelectableItem> expensesCategories;
  final Map<String, CategorySelectableItem> incomesCategories;
  final SignUpOnboardingStep step;
  final FormSubmitStatus status;
  final String? stepError;

  SignUpOnboardingState copyWith({
    Map<String, CategorySelectableItem>? expensesCategories,
    Map<String, CategorySelectableItem>? incomesCategories,
    SignUpOnboardingStep? step,
    FormSubmitStatus? status,
    String? Function()? stepError,
  }) {
    return SignUpOnboardingState(
      expensesCategories: expensesCategories ?? this.expensesCategories,
      incomesCategories: incomesCategories ?? this.incomesCategories,
      step: step ?? this.step,
      status: status ?? this.status,
      stepError: stepError != null ? stepError() : this.stepError,
    );
  }

  static const empty = SignUpOnboardingState(
    expensesCategories: {},
    incomesCategories: {},
    step: SignUpOnboardingStep.selectExpensesCategories,
    status: FormSubmitInitial(),
  );

  @override
  List<Object?> get props =>
      [expensesCategories, incomesCategories, step, status, stepError];
}
