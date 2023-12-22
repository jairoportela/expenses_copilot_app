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
  // Call super.pure to represent an unmodified form input.
  const TextInputValue.pure([String value = '']) : super.pure(value);

  // Call super.dirty to represent a modified form input.
  const TextInputValue.dirty([String value = '']) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  TextInputError? validator(String value) {
    return value.isEmpty ? TextInputError.empty : null;
  }
}
