import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';

class Income extends Transaction {
  const Income({
    required super.id,
    required super.name,
    required super.date,
    required super.category,
    required super.value,
    required super.createdAt,
  }) : super(type: CategoryType.income);

  factory Income.fromJson(Map<String, dynamic> json) {
    final Transaction(:category, :date, :id, :createdAt, :name, :value) =
        Transaction.fromJson(json);
    return Income(
      id: id,
      name: name,
      date: date,
      category: category,
      value: value,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        'category_id': category.id,
        'date': date.toUtc().toIso8601String(),
      };
}
