import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required AuthenticationRepository repository})
      : _repository = repository,
        super(SignUpState.empty);

  void onEmailChanged(String newValue) {
    final previousEmail = state.email;
    final shouldValidate = !previousEmail.isPure;
    final newState = state.copyWith(
      email: shouldValidate
          ? Email.validated(
              newValue,
              isAlreadyRegistered: newValue == previousEmail.value
                  ? previousEmail.isAlreadyRegistered
                  : false,
            )
          : Email.unvalidated(
              newValue,
            ),
    );
    emit(newState);
  }

  void onEmailUnfocused() {
    final newState = state.copyWith(
      email: Email.validated(
        state.email.value,
        isAlreadyRegistered: state.email.isAlreadyRegistered,
      ),
    );

    emit(newState);
  }

  void onPasswordChanged(String newValue) {
    final previousPassword = state.password;
    final shouldValidate = !previousPassword.isPure;
    final newState = state.copyWith(
      password: shouldValidate
          ? Password.validated(
              newValue,
            )
          : Password.unvalidated(
              newValue,
            ),
    );

    emit(newState);
  }

  void onPasswordUnfocused() {
    final newState = state.copyWith(
      password: Password.validated(
        state.password.value,
      ),
    );
    emit(newState);
  }

  void onPasswordConfirmationChanged(String newValue) {
    final previousPasswordConfirmation = state.passwordConfirmation;
    final shouldValidate = !previousPasswordConfirmation.isPure;
    final newState = state.copyWith(
      passwordConfirmation: shouldValidate
          ? PasswordConfirmation.validated(
              newValue,
              password: state.password.value,
            )
          : PasswordConfirmation.unvalidated(
              newValue,
            ),
    );
    emit(newState);
  }

  void onPasswordConfirmationUnfocused() {
    final newState = state.copyWith(
      passwordConfirmation: PasswordConfirmation.validated(
        state.passwordConfirmation.value,
        password: state.password.value,
      ),
    );
    emit(newState);
  }

  void onUsernameChanged(String newValue) {
    final previousUsername = state.username;
    final shouldValidate = !previousUsername.isPure;
    final newState = state.copyWith(
      username: shouldValidate
          ? TextInputValue.validated(
              newValue,
            )
          : TextInputValue.unvalidated(
              newValue,
            ),
    );
    emit(newState);
  }

  void onUsernameUnfocused() {
    final newState = state.copyWith(
      username: TextInputValue.validated(
        state.username.value,
      ),
    );

    emit(newState);
  }

  void onSubmit() async {
    final username = TextInputValue.validated(
      state.username.value,
    );

    final email = Email.validated(
      state.email.value,
      isAlreadyRegistered: state.email.isAlreadyRegistered,
    );

    final password = Password.validated(
      state.password.value,
    );

    final passwordConfirmation = PasswordConfirmation.validated(
      state.passwordConfirmation.value,
      password: password.value,
    );

    final isFormValid = Formz.validate([
          username,
          email,
          password,
          passwordConfirmation,
        ]) ==
        true;

    final newState = state.copyWith(
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      status: isFormValid ? const FormSubmitLoading() : null,
    );

    emit(newState);

    if (isFormValid) {
      try {
        await _repository.signUp(
          username: username.value,
          email: email.value,
          password: password.value,
        );
        final newState = state.copyWith(
          status: const FormSubmitSuccess(),
        );
        emit(newState);
      } catch (error) {
        final errorMessage = error is EmailAlreadyRegisteredException
            ? null
            : error is SignUpWithEmailAndPasswordFailure
                ? error.message
                : error.toString();

        final newState = state.copyWith(
          status: error is EmailAlreadyRegisteredException
              ? const FormSubmitInitial()
              : FormSubmitError(errorMessage!),
          username: state.username,
          email: error is EmailAlreadyRegisteredException
              ? Email.validated(
                  email.value,
                  isAlreadyRegistered: true,
                )
              : state.email,
        );

        emit(newState);
      }
    }
  }

  final AuthenticationRepository _repository;
}
