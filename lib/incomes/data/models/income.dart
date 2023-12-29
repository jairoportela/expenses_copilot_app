import 'package:expenses_copilot_app/categories/data/models/category.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';

class Income extends Transaction {
  const Income({
    required super.id,
    required super.name,
    required super.date,
    required super.category,
    required super.value,
  }) : super(type: CategoryType.income);

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
        id: json['id'],
        name: json['name'],
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        category: Category.fromJson(json['categories']),
        value: double.tryParse(((json['value'] ?? '0').toString())) ?? 0);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        'category_id': category.id,
        'date': date.toUtc().toIso8601String(),
      };
}
