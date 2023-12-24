part of 'expenses_overview_bloc.dart';

sealed class ExpensesOverviewEvent extends Equatable {
  const ExpensesOverviewEvent();

  @override
  List<Object> get props => [];
}

class ListenChangesExpensesEvent extends ExpensesOverviewEvent {}
