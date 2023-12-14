import 'package:authentication_repository/authentication_repository.dart';
import 'package:expenses_copilot_app/config/theme.dart';
import 'package:expenses_copilot_app/login/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesCopilotApp extends StatelessWidget {
  const ExpensesCopilotApp({
    super.key,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;
  final AuthenticationRepository _authRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MaterialApp(
        title: 'Expenses Copilot',
        theme: AppTheme.theme,
        home: const LoginScreen(),
      ),
    );
  }
}
