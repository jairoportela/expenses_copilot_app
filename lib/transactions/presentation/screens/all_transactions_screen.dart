import 'package:expenses_copilot_app/transactions/presentation/widgets/all_transactions_list.dart';
import 'package:flutter/material.dart';

class AllTransactionsScreen extends StatelessWidget {
  static const routeName = 'all-transactions';
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AllTransactionListBuilder(),
    );
  }
}
