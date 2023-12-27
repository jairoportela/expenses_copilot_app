import 'package:expenses_copilot_app/authentication/presentation/screens/login_screen.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/create_expense_screen.dart';
import 'package:expenses_copilot_app/home/presentation/screens/home_screen.dart';
import 'package:expenses_copilot_app/incomes/presentation/screens/create_income_screen.dart';
import 'package:expenses_copilot_app/transactions/presentation/screens/all_transactions_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          builder: (_) => const LoadingScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        );
      case CreateExpenseScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const CreateExpenseScreen(),
        );
      case CreateIncomeScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const CreateIncomeScreen(),
        );
      case AllTransactionsScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const AllTransactionsScreen(),
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
