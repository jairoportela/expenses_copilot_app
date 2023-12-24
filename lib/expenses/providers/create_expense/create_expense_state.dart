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
  final String categoryId;
  final String paymentMethodId;
  final TextInputValue name;
  final NumberInputValue value;
  final DateTime date;

  CreateExpenseState copyWith({
    FormSubmitStatus? status,
    String? categoryId,
    String? paymentMethodId,
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
    categoryId: '',
    paymentMethodId: '',
    name: const TextInputValue.unvalidated(),
    value: const NumberInputValue.unvalidated(),
    date: DateTime.now(),
  );

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
