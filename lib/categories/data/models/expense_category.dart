class ExpenseCategory {
  const ExpenseCategory({required this.id, required this.name});
  final String id;
  final String name;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(id: json['id'], name: json['name']);
  }
}
