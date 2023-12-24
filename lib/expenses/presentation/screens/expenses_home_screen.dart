import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/expenses/data/models/expense.dart';
import 'package:expenses_copilot_app/expenses/data/repository/expenses_repository.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/create_expense_screen.dart';
import 'package:expenses_copilot_app/expenses/providers/bloc/expenses_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:query_repository/query_repository.dart';

class ExpensesHomeScreen extends StatelessWidget {
  static const routeName = '/expenses';
  const ExpensesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                context.read<AppBloc>().add(const AppLogoutRequested());
              },
              icon: const Icon(Icons.logout),
              label: const Text(
                'Cerrar sesión',
              ),
            )
          ],
        ),
      )),
      appBar: AppBar(
        title: const Text('Gastos'),
      ),
      body: BlocProvider(
        create: (_) => ExpensesOverviewBloc(
          repository: ExpensesRepositoryImplementation(
            dataSource: RepositoryProvider.of<QueryRepository>(context),
          ),
        )..add(ListenChangesExpensesEvent()),
        child: const ListExpensesBuilder(),
      ),
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Gastos'),
        NavigationDestination(
            icon: Icon(Icons.settings), label: 'Configuración'),
      ]),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(CreateExpenseScreen.routeName),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListExpensesBuilder extends StatelessWidget {
  const ListExpensesBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesOverviewBloc, ExpensesOverviewState>(
      builder: (context, state) {
        final data = switch (state) {
          ExpensesOverviewSuccess() => state.data,
          _ => <Expense>[],
        };
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.expenseCategory.name),
              trailing: Text('\$${item.value.toString()}'),
            );
          },
          itemCount: data.length,
        );
      },
    );
  }
}
