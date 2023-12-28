part of 'categories_overview_cubit.dart';

sealed class CategoriesOverviewState extends Equatable {
  const CategoriesOverviewState();

  @override
  List<Object> get props => [];
}

final class CategoriesOverviewInitial extends CategoriesOverviewState {}

final class CategoriesOverviewLoading extends CategoriesOverviewState {}

final class CategoriesOverviewSuccess extends CategoriesOverviewState {
  const CategoriesOverviewSuccess(this.data);
  final List<Category> data;
}

final class CategoriesOverviewError extends CategoriesOverviewState {}
