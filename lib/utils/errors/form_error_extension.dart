extension FormErrorExtension on Object {
  String toMessage([String customError = 'Un error ha ocurrido']) {
    final error = this;
    return error.toString();
  }
}
