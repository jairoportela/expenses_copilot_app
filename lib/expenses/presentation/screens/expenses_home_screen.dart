import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/create_expense_screen.dart';
import 'package:expenses_copilot_app/transactions/presentation/screens/all_transactions_screen.dart';
import 'package:expenses_copilot_app/transactions/presentation/widgets/recents_transactions.dart';
import 'package:expenses_copilot_app/utils/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
      body: const HomeBuilder(),
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
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

class HomeBuilder extends StatelessWidget {
  const HomeBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1200px-User-avatar.svg.png',
              )),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
              ),
              iconSize: 30,
            )
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Diario financiero'),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios_rounded)),
                ),
                Card(
                  color:
                      const Color.fromRGBO(26, 63, 101, 0.187).withOpacity(0.1),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tu plata en diciembre'),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ingresos'),
                              Text('+ ${10000.0.toCOPFormat()}')
                            ],
                          ),
                          const Gap(5),
                          const LinearProgressIndicator(
                            value: 70 / 100,
                            color: Colors.greenAccent,
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Gastos'),
                              Text('- ${5000.0.toCOPFormat()}')
                            ],
                          ),
                          const Gap(5),
                          const LinearProgressIndicator(
                            value: 30 / 100,
                            color: Colors.redAccent,
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Recientes'),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AllTransactionsScreen.routeName);
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded)),
            ),
          ),
        ),
        const RecentTransactionListBuilder(),
      ],
    );
  }
}
