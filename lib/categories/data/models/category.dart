class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
  });
  final String id;
  final String name;
  final int? icon;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        icon: int.tryParse(json['icon'] ?? ''));
  }
}
