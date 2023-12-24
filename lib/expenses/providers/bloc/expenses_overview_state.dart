part of 'expenses_overview_bloc.dart';

sealed class ExpensesOverviewState extends Equatable {
  const ExpensesOverviewState();

  @override
  List<Object> get props => [];
}

final class ExpensesOverviewInitial extends ExpensesOverviewState {}

final class ExpensesOverviewLoading extends ExpensesOverviewState {}

final class ExpensesOverviewSuccess extends ExpensesOverviewState {
  const ExpensesOverviewSuccess(this.data);
  final List<Expense> data;

  @override
  List<Object> get props => [data];
}

final class ExpensesOverviewError extends ExpensesOverviewState {}
