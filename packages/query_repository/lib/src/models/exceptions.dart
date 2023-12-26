class QueryError implements Exception {
  const QueryError({required this.message});

  /// The associated error message.
  final String message;
}

class CreateError implements Exception {
  const CreateError({required this.message});

  /// The associated error message.
  final String message;
}
