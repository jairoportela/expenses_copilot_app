import 'package:expenses_copilot_app/authentication/presentation/screens/login_screen.dart';
import 'package:expenses_copilot_app/authentication/presentation/screens/sign_up_screen.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/create_expense_screen.dart';
import 'package:expenses_copilot_app/home/presentation/screens/home_screen.dart';
import 'package:expenses_copilot_app/incomes/presentation/screens/create_income_screen.dart';
import 'package:expenses_copilot_app/transactions/data/repository/transaction_repository.dart';
import 'package:expenses_copilot_app/transactions/presentation/screens/all_transactions_screen.dart';
import 'package:expenses_copilot_app/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:expenses_copilot_app/transactions/providers/delete_transaction/delete_transaction_cubit.dart';
import 'package:expenses_copilot_app/transactions/providers/transaction_detail/transaction_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crud_repository/crud_repository.dart';

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
      case SignUpScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const SignUpScreen(),
        );
      case CreateExpenseScreen.routeName:
        final data = settings.arguments as CreateExpenseArguments?;
        return MaterialPageRoute<bool?>(
          builder: (_) => CreateExpenseScreen(initialExpense: data),
        );
      case CreateIncomeScreen.routeName:
        final data = settings.arguments as CreateIncomeArguments?;
        return MaterialPageRoute<void>(
          builder: (_) => CreateIncomeScreen(initialIncome: data),
        );
      case AllTransactionsScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => const AllTransactionsScreen(),
        );
      case TransactionDetailScreen.routeName:
        final data = settings.arguments as TransactionDetailArguments;
        return MaterialPageRoute<void>(
          builder: (context) {
            final repository = TransactionRepositoryImplementation(
              dataSource: RepositoryProvider.of<CrudRepository>(context),
            );
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (ctx) => TransactionDetailCubit(
                    repository: repository,
                  )..getTransaction(data.id, data.type),
                ),
                BlocProvider(
                  create: (context) =>
                      DeleteTransactionCubit(repository: repository),
                ),
              ],
              child: TransactionDetailScreen(
                arguments: data,
              ),
            );
          },
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
