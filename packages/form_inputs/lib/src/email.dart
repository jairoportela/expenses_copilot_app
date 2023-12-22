import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

class Email extends FormzInput<String, EmailValidationError> {
  const Email.unvalidated([String value = '']) : super.pure(value);

  const Email.validated(String value) : super.dirty(value);

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!EmailValidator.validate(value)) return EmailValidationError.invalid;

    return null;
  }
}

enum EmailValidationError {
  empty('El campo no puede estar vacío'),
  invalid('Correo electrónico inválido');

  const EmailValidationError(this.error);

  final String error;
}
