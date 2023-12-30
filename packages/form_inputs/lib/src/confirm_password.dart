import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

class PasswordConfirmation
    extends FormzInput<String, PasswordConfirmationValidationError>
    with EquatableMixin {
  const PasswordConfirmation.unvalidated([
    String value = '',
  ])  : password = '',
        super.pure(value);

  const PasswordConfirmation.validated(
    String value, {
    required this.password,
  }) : super.dirty(value);

  final String password;

  @override
  PasswordConfirmationValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordConfirmationValidationError.empty
        : (value == password
            ? null
            : PasswordConfirmationValidationError.invalid);
  }

  @override
  List<Object?> get props => [value, isPure, password, isValid];
}

enum PasswordConfirmationValidationError {
  empty('La contraseña no puede estar vacia'),
  invalid('La contraseña no coincide');

  const PasswordConfirmationValidationError(this.error);

  final String error;
}
