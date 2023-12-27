import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:expenses_copilot_app/transactions/data/repository/transaction_repository.dart';
import 'package:expenses_copilot_app/transactions/presentation/widgets/transaction_filter.dart';
import 'package:expenses_copilot_app/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:expenses_copilot_app/transactions/providers/transactions_overview/transactions_overview_bloc.dart';
import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:query_repository/query_repository.dart';

class AllTransactionListBuilder extends StatelessWidget {
  const AllTransactionListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionsOverviewBloc(
        repository: TransactionRepositoryImplementation(
          dataSource: RepositoryProvider.of<QueryRepository>(context),
        ),
      )..add(const ListenChangesTransactionsEvent()),
      child: const ListTransactionsBuilder(),
    );
  }
}

class ListTransactionsBuilder extends StatelessWidget {
  const ListTransactionsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsOverviewBloc, TransactionsOverviewState>(
      builder: (context, state) {
        final data = switch (state) {
          TransactionsOverviewSuccess() => state.data,
          _ => <Transaction>[],
        };

        Map<String, List<Transaction>> groupExpenses = {};

        // Agrupa los gastos por día
        for (var expense in data) {
          final String formatDate = expense.date.formatDateTitle();

          if (!groupExpenses.containsKey(formatDate)) {
            groupExpenses[formatDate] = [];
          }

          groupExpenses[formatDate]!.add(expense);
        }

        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: TransactionFilterRow(
                  onSelected: (TransactionTypeFilter value) {
                    context
                        .read<TransactionsOverviewBloc>()
                        .add(ListenChangesTransactionsEvent(value));
                  },
                ),
              ),
            ),
            if (state is TransactionsOverviewLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (state is TransactionsOverviewSuccess && data.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text('No hay información en el momento'),
                ),
              ),
            for (var key in groupExpenses.keys) ...[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    key,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.builder(
                  itemBuilder: (context, index) {
                    final item = groupExpenses[key]![index];
                    return TransactionListItem(item: item);
                  },
                  itemCount: groupExpenses[key]!.length,
                ),
              )
            ]
          ],
        );
      },
    );
  }
}
