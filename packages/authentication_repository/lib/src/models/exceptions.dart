import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthError implements Exception {
  const AuthError({required this.message});

  /// The associated error message.
  final String message;
}

class SignUpWithEmailAndPasswordFailure extends AuthError {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    String message = 'Un error ha ocurrido.',
  ]) : super(message: message);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromException(
      supabase.AuthException error) {
    return const SignUpWithEmailAndPasswordFailure(
      'El correo no es válido.',
    );
  }
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure extends AuthError {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    String message = 'Un error ha ocurrido.',
  ]) : super(message: message);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromException(
      supabase.AuthException error) {
    return const LogInWithEmailAndPasswordFailure(
      'El correo no es válido.',
    );
  }
}
