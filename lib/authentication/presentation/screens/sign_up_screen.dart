import 'package:authentication_repository/authentication_repository.dart';
import 'package:expenses_copilot_app/authentication/presentation/screens/login_screen.dart';
import 'package:expenses_copilot_app/authentication/presentation/widgets/signup_submit_button.dart';
import 'package:expenses_copilot_app/authentication/providers/sign_up_cubit/sign_up_cubit.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/authentication/presentation/widgets/email_form_field.dart';
import 'package:expenses_copilot_app/authentication/presentation/widgets/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gap/gap.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = '/sign-up';
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
        repository: RepositoryProvider.of<AuthenticationRepository>(context),
      ),
      child: GestureDetector(
        onTap: () => _releaseFocus(context),
        child: Scaffold(
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(100),
                Text(
                  'Crear cuenta',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const Gap(20),
                const SignUpForm(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                  child: const Text(
                    'Ya tienes cuenta, inicia sesión aquí',
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const CustomBottomAppBar(
            child: SingUpSubmitButton(),
          ),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();

  @override
  void initState() {
    final cubit = context.read<SignUpCubit>();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        cubit.onEmailUnfocused();
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        cubit.onPasswordUnfocused();
      }
    });
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        cubit.onPasswordConfirmationUnfocused();
      }
    });
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        cubit.onUsernameUnfocused();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        children: [
          BlocSelector<SignUpCubit, SignUpState, TextInputValue>(
            selector: (state) {
              return state.username;
            },
            builder: (context, username) {
              return CustomInputField(
                title: 'Nombre *',
                child: CustomTextFormField(
                  focusNode: _usernameFocusNode,
                  onChanged: context.read<SignUpCubit>().onUsernameChanged,
                  text: username,
                  fieldSettings: const TextFieldSettings(
                    textInputAction: TextInputAction.next,
                    autoFillHints: [AutofillHints.name],
                    textInputType: TextInputType.name,
                  ),
                ),
              );
            },
          ),
          const Gap(20),
          BlocSelector<SignUpCubit, SignUpState, Email>(
            selector: (state) {
              return state.email;
            },
            builder: (context, email) {
              return CustomInputField(
                title: 'Correo *',
                child: EmailFormField(
                  focusNode: _emailFocusNode,
                  onChanged: context.read<SignUpCubit>().onEmailChanged,
                  text: email,
                  fieldSettings: const TextFieldSettings(
                    autoFillHints: [AutofillHints.newUsername],
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                ),
              );
            },
          ),
          const Gap(20),
          BlocSelector<SignUpCubit, SignUpState, Password>(
            selector: (state) {
              return state.password;
            },
            builder: (context, password) {
              return CustomInputField(
                title: 'Contraseña *',
                child: PasswordFormField(
                  focusNode: _passwordFocusNode,
                  onChanged: context.read<SignUpCubit>().onPasswordChanged,
                  text: password,
                  fieldSettings: const TextFieldSettings(
                    textInputAction: TextInputAction.next,
                    autoFillHints: [AutofillHints.newPassword],
                    textInputType: TextInputType.visiblePassword,
                  ),
                  onEditingComplete: null,
                ),
              );
            },
          ),
          const Gap(20),
          BlocSelector<SignUpCubit, SignUpState, PasswordConfirmation>(
            selector: (state) {
              return state.passwordConfirmation;
            },
            builder: (context, passwordConfirmation) {
              return CustomInputField(
                title: 'Confirmar contraseña *',
                child: ConfirmPasswordFormField(
                  onEditingComplete: () {
                    TextInput.finishAutofillContext();
                    context.read<SignUpCubit>().onSubmit();
                  },
                  focusNode: _confirmPasswordFocusNode,
                  onChanged:
                      context.read<SignUpCubit>().onPasswordConfirmationChanged,
                  text: passwordConfirmation,
                  fieldSettings: const TextFieldSettings(
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                  ),
                ),
              );
            },
          ),
          const Gap(20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }
}
