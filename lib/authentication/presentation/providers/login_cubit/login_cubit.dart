import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/utils/errors/form_error_extension.dart';
import 'package:form_inputs/form_inputs.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthenticationRepository repository})
      : _repository = repository,
        super(LoginState.empty);

  void onChangeEmail(String value) {
    final previousEmail = state.email;
    final shouldValidate = previousEmail.isNotValid;
    final newState = state.copyWith(
      email: shouldValidate
          ? Email.unvalidated(
              value,
            )
          : Email.validated(
              value,
            ),
    );
    emit(newState);
  }

  void onChangeFocusEmail() {
    final previousEmailState = state.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.validated(
      previousEmailValue,
    );
    final newScreenState = state.copyWith(
      email: newEmailState,
    );
    emit(newScreenState);
  }

  void onChangePassword(String value) {
    final previousPassword = state.password;
    final shouldValidate = previousPassword.isNotValid;
    final newState = state.copyWith(
      password: shouldValidate
          ? Password.unvalidated(
              value,
            )
          : Password.validated(
              value,
            ),
    );
    emit(newState);
  }

  void onChangeFocusPassword() {
    final previousPasswordState = state.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.validated(
      previousPasswordValue,
    );
    final newScreenState = state.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  void onSubmit() async {
    try {
      final finalState = state.copyWith(
        email: Email.validated(state.email.value),
        password: Password.validated(state.password.value),
      );
      emit(finalState);

      if (finalState.email.isNotValid || finalState.password.isNotValid) return;

      emit(state.copyWith(status: const FormSubmitLoading()));

      await _repository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: const FormSubmitSuccess()));
    } catch (error) {
      emit(state.copyWith(status: FormSubmitError(error.toMessage())));
    }
  }

  final AuthenticationRepository _repository;
}
