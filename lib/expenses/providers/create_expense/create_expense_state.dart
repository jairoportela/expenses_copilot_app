part of 'create_expense_cubit.dart';

class CreateExpenseState extends Equatable {
  const CreateExpenseState({
    required this.status,
    required this.categoryId,
    required this.name,
    required this.paymentMethodId,
    required this.value,
    required this.date,
  });

  final FormSubmitStatus status;
  final TextInputValue categoryId;
  final TextInputValue paymentMethodId;
  final TextInputValue name;
  final NumberInputValue value;
  final DateTime date;

  CreateExpenseState copyWith({
    FormSubmitStatus? status,
    TextInputValue? categoryId,
    TextInputValue? paymentMethodId,
    TextInputValue? name,
    NumberInputValue? value,
    DateTime? date,
  }) {
    return CreateExpenseState(
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      name: name ?? this.name,
      value: value ?? this.value,
      date: date ?? this.date,
    );
  }

  static CreateExpenseState empty = CreateExpenseState(
    status: const FormSubmitInitial(),
    categoryId: const TextInputValue.unvalidated(),
    paymentMethodId: const TextInputValue.unvalidated(),
    name: const TextInputValue.unvalidated(),
    value: const NumberInputValue.unvalidated(),
    date: DateTime.now().withoutHours,
  );
  factory CreateExpenseState.fromExpense(Expense expense) => CreateExpenseState(
        status: const FormSubmitInitial(),
        categoryId: TextInputValue.validated(expense.category.id),
        paymentMethodId: TextInputValue.validated(expense.paymentMethod.id),
        name: TextInputValue.unvalidated(expense.name),
        value: NumberInputValue.unvalidated(expense.value.toString()),
        date: expense.date.withoutHours,
      );

  Map<String, dynamic> toJson() => {
        'name': name.value,
        'value': double.tryParse(value.value) ?? 0,
        'category_id': categoryId.value,
        'payment_id': paymentMethodId.value,
        'date': date.toUtc().toIso8601String(),
      };

  bool get isNotValid =>
      categoryId.isNotValid ||
      paymentMethodId.isNotValid ||
      value.isNotValid ||
      name.isNotValid;
  bool get isValid => !isNotValid;

  @override
  List<Object> get props => [
        status,
        categoryId,
        paymentMethodId,
        name,
        value,
        date,
      ];
}
