import 'package:formz/formz.dart';

enum TextInputError {
  empty(message: 'El campo no puede estar vacío.');

  const TextInputError({
    required this.message,
  });

  final String message;
}

// Extend FormzInput and provide the input type and error type.
class TextInputValue extends FormzInput<String, TextInputError> {
  const TextInputValue.unvalidated([String value = '']) : super.pure(value);

  const TextInputValue.validated([String value = '']) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  TextInputError? validator(String value) {
    return value.isEmpty ? TextInputError.empty : null;
  }
}
