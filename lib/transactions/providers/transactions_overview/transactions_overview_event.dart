part of 'transactions_overview_bloc.dart';

sealed class TransactionsOverviewEvent extends Equatable {
  const TransactionsOverviewEvent();

  @override
  List<Object> get props => [];
}

class ListenRecentTransactionsEvent extends TransactionsOverviewEvent {}

class ListenChangesTransactionsEvent extends TransactionsOverviewEvent {
  const ListenChangesTransactionsEvent(
      [this.filter = TransactionTypeFilter.all]);
  final TransactionTypeFilter filter;
}

enum TransactionTypeFilter {
  all(type: null, name: 'Todos'),
  incomes(type: CategoryType.income, name: 'Ingresos'),
  expenses(type: CategoryType.expense, name: 'Gastos');

  const TransactionTypeFilter({
    required this.type,
    required this.name,
  });
  final CategoryType? type;
  final String name;
}
