part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    required this.email,
    required this.password,
    required this.status,
    required this.username,
    required this.passwordConfirmation,
  });
  final Email email;
  final Password password;
  final PasswordConfirmation passwordConfirmation;
  final TextInputValue username;
  final FormSubmitStatus status;

  SignUpState copyWith({
    Email? email,
    Password? password,
    PasswordConfirmation? passwordConfirmation,
    TextInputValue? username,
    FormSubmitStatus? status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      username: username ?? this.username,
    );
  }

  static const empty = SignUpState(
    email: Email.unvalidated(),
    password: Password.unvalidated(),
    username: TextInputValue.unvalidated(),
    passwordConfirmation: PasswordConfirmation.unvalidated(),
    status: FormSubmitInitial(),
  );

  @override
  List<Object> get props => [
        email,
        password,
        status,
        passwordConfirmation,
        username,
      ];
}
