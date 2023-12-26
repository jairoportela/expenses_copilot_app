import 'package:authentication_repository/authentication_repository.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/authentication/providers/login_cubit/login_cubit.dart';
import 'package:expenses_copilot_app/authentication/presentation/widgets/email_form_field.dart';
import 'package:expenses_copilot_app/authentication/presentation/widgets/password_form_field.dart';
import 'package:expenses_copilot_app/authentication/presentation/widgets/signin_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        repository: RepositoryProvider.of<AuthenticationRepository>(context),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 100),
              Text(
                'Inicio de sesión',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 20),
              const SignInForm(),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomAppBar(
          child: SingInSubmitButton(),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    final cubit = context.read<LoginCubit>();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        cubit.onChangeFocusEmail();
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        cubit.onChangeFocusPassword();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        children: [
          BlocSelector<LoginCubit, LoginState, Email>(
            selector: (state) {
              return state.email;
            },
            builder: (context, email) {
              return CustomInputField(
                title: 'Correo *',
                child: EmailFormField(
                  focusNode: _emailFocusNode,
                  onChanged: context.read<LoginCubit>().onChangeEmail,
                  text: email,
                  fieldSettings: const TextFieldSettings(
                    autoFillHints: [AutofillHints.username],
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          BlocSelector<LoginCubit, LoginState, Password>(
            selector: (state) {
              return state.password;
            },
            builder: (context, password) {
              return CustomInputField(
                title: 'Contraseña *',
                child: PasswordFormField(
                  onEditingComplete: () {
                    TextInput.finishAutofillContext();
                    context.read<LoginCubit>().onSubmit();
                  },
                  focusNode: _passwordFocusNode,
                  onChanged: context.read<LoginCubit>().onChangePassword,
                  text: password,
                  fieldSettings: const TextFieldSettings(
                    textInputAction: TextInputAction.done,
                    autoFillHints: [AutofillHints.password],
                    textInputType: TextInputType.visiblePassword,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
