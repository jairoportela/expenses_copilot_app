import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class Email extends FormzInput<String, EmailValidationError>
    with EquatableMixin {
  const Email.unvalidated([String value = ''])
      : isAlreadyRegistered = false,
        super.pure(value);

  const Email.validated(
    String value, {
    this.isAlreadyRegistered = false,
  }) : super.dirty(value);

  final bool isAlreadyRegistered;

  @override
  EmailValidationError? validator(String value) {
    return value.isEmpty
        ? EmailValidationError.empty
        : (isAlreadyRegistered
            ? EmailValidationError.alreadyRegistered
            : (EmailValidator.validate(value)
                ? null
                : EmailValidationError.invalid));
  }

  @override
  List<Object?> get props => [
        value,
        isPure,
        isAlreadyRegistered,
      ];
}

enum EmailValidationError {
  empty('El campo no puede estar vacío'),
  invalid('Correo electrónico inválido'),
  alreadyRegistered('Correo electrónico ya registrado');

  const EmailValidationError(this.error);

  final String error;
}
