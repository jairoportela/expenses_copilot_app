import 'package:formz/formz.dart';

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.unvalidated([String value = '']) : super.pure(value);

  const Password.validated([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationError.noUppercase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationError.noLowercase;
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return PasswordValidationError.noDigit;
    }
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return PasswordValidationError.noSpecialCharacter;
    }
    return null;
  }
}

enum PasswordValidationError {
  tooShort('La contraseña es muy corta'),
  noDigit('La contraseña necesita al menos un dígito'),
  noUppercase('La contraseña necesita al menos una mayúscula'),
  noLowercase('La contraseña necesita al menos una minúscula'),
  noSpecialCharacter('La contraseña necesita al menos un carácter especial');

  const PasswordValidationError(this.error);

  final String error;
}
