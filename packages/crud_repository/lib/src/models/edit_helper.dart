class EditHelper {
  const EditHelper({
    required this.tableName,
    required this.data,
    required this.columnName,
    required this.value,
  });

  final String tableName;

  final Map<String, dynamic> data;
  final String columnName;
  final String value;
}
