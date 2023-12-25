class QueryHelper<R> {
  const QueryHelper({
    required this.tableName,
    required this.selectString,
    required this.fromJson,
    this.filter,
    this.orderFilter,
  });

  final String tableName;
  final String selectString;
  final Map<String, dynamic>? filter;
  final OrderFilter? orderFilter;
  final R Function(Map<String, dynamic> json) fromJson;
}

class OrderFilter {
  const OrderFilter({
    required this.ascending,
    required this.columnName,
  });
  final String columnName;
  final bool ascending;
}
