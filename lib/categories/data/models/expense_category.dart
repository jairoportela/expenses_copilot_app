class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
  final String id;
  final String name;
  final int? icon;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
        id: json['id'],
        name: json['name'],
        icon: int.tryParse(json['icon'] ?? ''));
  }
}
