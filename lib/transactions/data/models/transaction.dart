import 'package:expenses_copilot_app/categories/data/models/category.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';

class Transaction {
  const Transaction({
    required this.id,
    required this.name,
    required this.date,
    required this.category,
    required this.value,
    required this.type,
    required this.createdAt,
  });
  final String id;
  final String name;
  final DateTime date;
  final Category category;
  final double value;
  final CategoryType type;
  final DateTime createdAt;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      name: json['name'],
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      category: Category.fromJson(json['categories']),
      value: double.tryParse(((json['value'] ?? '0').toString())) ?? 0,
      type: getCategoryByKey(json['type']),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
