part of 'create_income_cubit.dart';

class CreateIncomeState extends Equatable {
  const CreateIncomeState({
    required this.status,
    required this.categoryId,
    required this.name,
    required this.value,
    required this.date,
  });

  final FormSubmitStatus status;
  final TextInputValue categoryId;

  final TextInputValue name;
  final NumberInputValue value;
  final DateTime date;

  CreateIncomeState copyWith({
    FormSubmitStatus? status,
    TextInputValue? categoryId,
    TextInputValue? paymentMethodId,
    TextInputValue? name,
    NumberInputValue? value,
    DateTime? date,
  }) {
    return CreateIncomeState(
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      value: value ?? this.value,
      date: date ?? this.date,
    );
  }

  static CreateIncomeState empty = CreateIncomeState(
    status: const FormSubmitInitial(),
    categoryId: const TextInputValue.unvalidated(),
    name: const TextInputValue.unvalidated(),
    value: const NumberInputValue.unvalidated(),
    date: DateTime.now().withoutHours,
  );
  factory CreateIncomeState.fromIncome(Income income) => CreateIncomeState(
        status: const FormSubmitInitial(),
        categoryId: TextInputValue.validated(income.category.id),
        name: TextInputValue.validated(income.name),
        value: NumberInputValue.validated(income.value.toStringAsFixed(0)),
        date: DateTime.now().withoutHours,
      );

  Income toIncome([String? id]) => Income(
        id: id ?? '',
        name: name.value,
        date: date,
        category: Category(id: categoryId.value, name: '', icon: null),
        value: double.tryParse(value.value) ?? 0,
        createdAt: DateTime.now(),
      );

  bool get isNotValid =>
      categoryId.isNotValid || value.isNotValid || name.isNotValid;
  bool get isValid => !isNotValid;

  @override
  List<Object> get props => [
        status,
        categoryId,
        name,
        value,
        date,
      ];
}
