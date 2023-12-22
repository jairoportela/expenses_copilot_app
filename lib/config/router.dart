import 'package:expenses_copilot_app/authentication/presentation/screens/login_screen.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/create_expense_screen.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/expenses_home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          builder: (_) => const LoadingScreen(),
        );
      case ExpensesHomeScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const ExpensesHomeScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        );
      case CreateExpenseScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const CreateExpenseScreen(),
        );

      default:
        throw const RouteException('Ruta no encontrada');
    }
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Cargando...'),
      ),
    );
  }
}

/// Exception thrown when a given route doesn't exist
class RouteException implements Exception {
  const RouteException(this.message);

  final String message;
}
