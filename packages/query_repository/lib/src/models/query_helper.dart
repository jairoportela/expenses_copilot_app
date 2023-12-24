class QueryHelper {
  const QueryHelper({
    required this.tableName,
    required this.selectString,
    this.filter,
    required this.fromJson,
  });

  final String tableName;
  final String selectString;
  final Map<String, dynamic>? filter;
  final R Function<R>(Map<String, dynamic> json) fromJson;
}
