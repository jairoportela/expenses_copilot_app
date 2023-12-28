part of 'monthly_summary_bloc.dart';

sealed class MonthlySummaryEvent extends Equatable {
  const MonthlySummaryEvent();

  @override
  List<Object> get props => [];
}

class ListenMonthlySummaryEvent extends MonthlySummaryEvent {
  const ListenMonthlySummaryEvent(this.month);
  final DateTime month;
}
