import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/monthly_statistics/data/models/monthly_summary.dart';
import 'package:expenses_copilot_app/monthly_statistics/data/repositories/monthly_summary_repository.dart';

part 'monthly_summary_event.dart';
part 'monthly_summary_state.dart';

class MonthlySummaryBloc
    extends Bloc<MonthlySummaryEvent, MonthlySummaryState> {
  MonthlySummaryBloc({required MonthlySummaryRepository repository})
      : _repository = repository,
        super(MonthlySummaryInitial()) {
    on<ListenMonthlySummaryEvent>((event, emit) {
      emit(MonthlySummaryLoading());
      return emit.forEach(
        _repository.getSummary(month: event.month),
        onData: (data) => MonthlySummarySuccess(data),
      );
    });
  }

  final MonthlySummaryRepository _repository;
}
