class QueryHelper<R> {
  const QueryHelper({
    required this.tableName,
    required this.selectString,
    required this.fromJson,
    this.filter,
    this.orderFilter,
    this.inFilter,
  });

  final String tableName;
  final String selectString;
  final Map<String, dynamic>? filter;
  final InFilter? inFilter;
  final List<OrderFilter>? orderFilter;

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

class InFilter {
  const InFilter({
    required this.columnName,
    required this.dataToFilter,
  });
  final String columnName;
  final List<String> dataToFilter;
}
