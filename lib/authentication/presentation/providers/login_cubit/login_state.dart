part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
  });
  final Email email;
  final Password password;
  final FormSubmitStatus status;

  LoginState copyWith({
    Email? email,
    Password? password,
    FormSubmitStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  static const empty = LoginState(
    email: Email.unvalidated(),
    password: Password.unvalidated(),
    status: FormSubmitInitial(),
  );

  @override
  List<Object> get props => [
        email,
        password,
        status,
      ];
}
