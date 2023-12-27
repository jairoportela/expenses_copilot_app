import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/create_expense_screen.dart';
import 'package:expenses_copilot_app/home/presentation/widgets/expandable_fab.dart';
import 'package:expenses_copilot_app/incomes/presentation/screens/create_income_screen.dart';
import 'package:expenses_copilot_app/transactions/presentation/screens/all_transactions_screen.dart';
import 'package:expenses_copilot_app/transactions/presentation/widgets/recents_transactions.dart';
import 'package:expenses_copilot_app/utils/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _myPage;

  int _currentPage = 0;

  @override
  void initState() {
    _myPage = PageController(initialPage: _currentPage);
    super.initState();
  }

  void _showAction(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).pushNamed(CreateExpenseScreen.routeName);
    }
    if (index == 1) {
      Navigator.of(context).pushNamed(CreateIncomeScreen.routeName);
    }
  }

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
      body: PageView(
        controller: _myPage,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeBuilder(),
          Center(
            child: SizedBox(
              child: Text('En construcción 1'),
            ),
          ),
          Center(
            child: SizedBox(
              child: Text('En construcción 2'),
            ),
          ),
        ], // Comment this if you need to use Swipe.
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            NavigationButton(
              isSelected: _currentPage == 0,
              onSelected: () {
                _myPage.jumpToPage(0);
              },
              icon: Icons.home,
              label: 'Home',
            ),
            NavigationButton(
              isSelected: _currentPage == 1,
              onSelected: () {
                _myPage.jumpToPage(1);
              },
              icon: Icons.bar_chart_rounded,
              label: 'Estadísticas',
            ),
            NavigationButton(
              isSelected: _currentPage == 2,
              onSelected: () {
                _myPage.jumpToPage(2);
              },
              icon: Icons.settings,
              label: 'Configuración',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: ExpandableFab(
        distance: 60,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.money_off),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.attach_money),
          ),
        ],
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

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    super.key,
    required this.isSelected,
    required this.onSelected,
    required this.icon,
    required this.label,
  });

  final bool isSelected;
  final VoidCallback onSelected;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Theme.of(context).colorScheme.surface,
      tooltip: label,
      icon: isSelected
          ? Chip(
              elevation: 1,
              backgroundColor: const Color.fromRGBO(159, 202, 255, 0.28),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              label: Icon(
                icon,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            )
          : Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      onPressed: onSelected,
    );
  }
}
