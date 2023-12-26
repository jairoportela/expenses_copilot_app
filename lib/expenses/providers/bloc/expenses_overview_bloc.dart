import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/expenses/data/models/expense.dart';
import 'package:expenses_copilot_app/expenses/data/repository/expenses_repository.dart';

part 'expenses_overview_event.dart';
part 'expenses_overview_state.dart';

class ExpensesOverviewBloc
    extends Bloc<ExpensesOverviewEvent, ExpensesOverviewState> {
  ExpensesOverviewBloc({
    required ExpensesRepository repository,
  })  : _repository = repository,
        super(ExpensesOverviewInitial()) {
    on<ListenChangesExpensesEvent>((event, emit) {
      return emit.forEach(
        _repository.getAll(),
        onData: (data) => ExpensesOverviewSuccess(data),
      );
    });
  }

  final ExpensesRepository _repository;
}
