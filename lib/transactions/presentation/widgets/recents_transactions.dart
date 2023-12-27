import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:expenses_copilot_app/transactions/data/repository/transaction_repository.dart';
import 'package:expenses_copilot_app/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:expenses_copilot_app/transactions/providers/transactions_overview/transactions_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:query_repository/query_repository.dart';

class RecentTransactionListBuilder extends StatelessWidget {
  const RecentTransactionListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionsOverviewBloc(
        repository: TransactionRepositoryImplementation(
          dataSource: RepositoryProvider.of<QueryRepository>(context),
        ),
      )..add(ListenRecentTransactionsEvent()),
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

        if (state is TransactionsOverviewLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (data.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('No hay información en el momento'),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return TransactionListItem(item: item);
            },
          ),
        );
      },
    );
  }
}
