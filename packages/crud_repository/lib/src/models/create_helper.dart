class CreateHelper {
  const CreateHelper({
    required this.tableName,
    required this.data,
  });

  final String tableName;

  final Map<String, dynamic> data;
}

class CreateHelperWithValue<R> {
  const CreateHelperWithValue({
    required this.tableName,
    required this.selectString,
    required this.data,
    required this.fromJson,
  });

  final String tableName;
  final String selectString;
  final Map<String, dynamic> data;
  final R Function(Map<String, dynamic> json) fromJson;
}
