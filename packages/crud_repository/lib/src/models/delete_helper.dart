class DeleteHelper {
  const DeleteHelper({
    required this.tableName,
    required this.columnName,
    required this.valueToDelete,
  });

  final String tableName;
  final String columnName;
  final String valueToDelete;
}
