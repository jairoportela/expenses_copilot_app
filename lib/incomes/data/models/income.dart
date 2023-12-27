import 'package:expenses_copilot_app/categories/data/models/category.dart';

class Income {
  const Income({
    required this.id,
    required this.name,
    required this.date,
    required this.category,
    required this.value,
  });
  final String id;
  final String name;
  final DateTime date;
  final Category category;
  final double value;

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
