enum CategoryType {
  expense('expense', 'gasto'),
  income('income', 'ingreso');

  const CategoryType(
    this.name,
    this.title,
  );

  final String name;
  final String title;
}

CategoryType getCategoryByKey(String? key) {
  if (_categoriesMap.containsKey(key)) return _categoriesMap[key]!;
  return CategoryType.expense;
}

Map<String, CategoryType> _categoriesMap = {
  'expense': CategoryType.expense,
  'income': CategoryType.income,
};
