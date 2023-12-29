import 'package:expenses_copilot_app/categories/data/models/category.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';

class Expense extends Transaction {
  const Expense({
    required super.id,
    required super.category,
    required super.date,
    required super.value,
    required super.name,
    required this.paymentMethod,
  }) : super(type: CategoryType.expense);

  final PaymentMethod paymentMethod;

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      category: Category.fromJson(json['categories']),
      paymentMethod: PaymentMethod.fromJson(json['payment_methods']),
      value: double.tryParse(((json['value'] ?? '0').toString())) ?? 0,
    );
  }
}
