import 'package:expenses_copilot_app/categories/data/models/category_type.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });
  final String id;
  final String name;
  final int? icon;
  final CategoryType type;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: int.tryParse(
        json['icon'] ?? '',
      ),
      type: getCategoryByKey(json['type']),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'name': name, 'type': type.name};
    if (icon != null) {
      data['icon'] = icon!;
    }
    return data;
  }
}
