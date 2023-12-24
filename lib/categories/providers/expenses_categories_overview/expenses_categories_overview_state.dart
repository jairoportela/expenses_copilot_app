part of 'expenses_categories_overview_cubit.dart';

sealed class ExpensesCategoriesOverviewState extends Equatable {
  const ExpensesCategoriesOverviewState();

  @override
  List<Object> get props => [];
}

final class ExpensesCategoriesOverviewInitial
    extends ExpensesCategoriesOverviewState {}

final class ExpensesCategoriesOverviewLoading
    extends ExpensesCategoriesOverviewState {}

final class ExpensesCategoriesOverviewSuccess
    extends ExpensesCategoriesOverviewState {
  const ExpensesCategoriesOverviewSuccess(this.data);
  final List<ExpenseCategory> data;
}

final class ExpensesCategoriesOverviewError
    extends ExpensesCategoriesOverviewState {}
