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
    required super.createdAt,
    required this.paymentMethod,
  }) : super(type: CategoryType.expense);

  final PaymentMethod paymentMethod;

  factory Expense.fromJson(Map<String, dynamic> json) {
    final Transaction(:category, :date, :id, :createdAt, :name, :value) =
        Transaction.fromJson(json);
    return Expense(
      id: id,
      name: name,
      date: date,
      category: category,
      paymentMethod: PaymentMethod.fromJson(json['payment_methods']),
      value: value,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        'category_id': category.id,
        'payment_id': paymentMethod.id,
        'date': date.toUtc().toIso8601String(),
      };
}
