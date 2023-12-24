import 'package:expenses_copilot_app/categories/data/models/expense_category.dart';
import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';

class Expense {
  const Expense({
    required this.id,
    required this.name,
    required this.date,
    required this.expenseCategory,
    required this.paymentMethod,
    required this.value,
  });
  final String id;
  final String name;
  final DateTime date;
  final ExpenseCategory expenseCategory;
  final PaymentMethod paymentMethod;
  final double value;

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
        id: json['id'],
        name: json['name'],
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        expenseCategory: ExpenseCategory.fromJson(json['expenses_categories']),
        paymentMethod: PaymentMethod.fromJson(json['payment_methods']),
        value: double.tryParse(((json['value'] ?? '0').toString())) ?? 0);
  }
}
