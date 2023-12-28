part of 'transactions_overview_bloc.dart';

sealed class TransactionsOverviewState extends Equatable {
  const TransactionsOverviewState();

  @override
  List<Object> get props => [];
}

final class TransactionsOverviewInitial extends TransactionsOverviewState {}

final class TransactionsOverviewLoading extends TransactionsOverviewState {}

final class TransactionsOverviewSuccess extends TransactionsOverviewState {
  const TransactionsOverviewSuccess(this.data);
  final List<Transaction> data;

  @override
  List<Object> get props => [data];
}

final class TransactionsOverviewError extends TransactionsOverviewState {}
