part of 'monthly_summary_bloc.dart';

sealed class MonthlySummaryState extends Equatable {
  const MonthlySummaryState();

  @override
  List<Object> get props => [];
}

final class MonthlySummaryInitial extends MonthlySummaryState {}

final class MonthlySummaryLoading extends MonthlySummaryState {}

final class MonthlySummarySuccess extends MonthlySummaryState {
  const MonthlySummarySuccess(this.data);
  final MonthlySummary data;

  @override
  List<Object> get props => [data];
}

final class MonthlySummaryError extends MonthlySummaryState {}
