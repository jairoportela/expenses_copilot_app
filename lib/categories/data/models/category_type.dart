enum CategoryType {
  expense('expense'),
  income('income');

  const CategoryType(this.name);

  final String name;
}

CategoryType getCategoryByKey(String? key) {
  if (_categoriesMap.containsKey(key)) return _categoriesMap[key]!;
  return CategoryType.expense;
}

Map<String, CategoryType> _categoriesMap = {
  'expense': CategoryType.expense,
  'income': CategoryType.income,
};
