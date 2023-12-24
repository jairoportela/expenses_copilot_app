import 'package:authentication_repository/authentication_repository.dart';
import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/authentication/presentation/screens/login_screen.dart';
import 'package:expenses_copilot_app/config/router.dart';
import 'package:expenses_copilot_app/config/theme.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/expenses_home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      child: BlocProvider(
        lazy: false,
        create: (_) => AppBloc(authenticationRepository: _authRepository)
          ..add(AppUserChanged()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({
    super.key,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Expenses Copilot',
      theme: AppTheme.theme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'CO'),
        Locale('es', 'MX'),
      ],
      builder: (context, child) {
        return BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            switch (state.status) {
              case AppStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                  ExpensesHomeScreen.routeName,
                  (route) => false,
                );
              case AppStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                  LoginScreen.routeName,
                  (route) => false,
                );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
