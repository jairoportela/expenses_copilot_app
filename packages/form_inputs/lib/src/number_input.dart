// Define input validation errors
import 'package:formz/formz.dart';

enum NumberInputError {
  empty(message: 'El campo no puede estar vacío.'),
  notNumber(message: 'El campo no es un número.');

  const NumberInputError({
    required this.message,
  });

  final String message;
}

// Extend FormzInput and provide the input type and error type.
class NumberInputValue extends FormzInput<String, NumberInputError> {
  // Call super.pure to represent an unmodified form input.
  const NumberInputValue.unvalidated([String value = '']) : super.pure(value);

  // Call super.dirty to represent a modified form input.
  const NumberInputValue.validated([String value = '']) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  NumberInputError? validator(String value) {
    return value.isEmpty ? NumberInputError.empty : null;
  }
}
