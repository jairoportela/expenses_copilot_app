import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:expenses_copilot_app/transactions/data/repository/transaction_repository.dart';

part 'transactions_overview_event.dart';
part 'transactions_overview_state.dart';

class TransactionsOverviewBloc
    extends Bloc<TransactionsOverviewEvent, TransactionsOverviewState> {
  TransactionsOverviewBloc({
    required TransactionRepository repository,
  })  : _repository = repository,
        super(TransactionsOverviewInitial()) {
    on<ListenRecentTransactionsEvent>((event, emit) {
      emit(TransactionsOverviewLoading());
      return emit.forEach(
        _repository.getRecents(),
        onData: (data) => TransactionsOverviewSuccess(data),
      );
    });
    on<ListenChangesTransactionsEvent>((event, emit) {
      emit(TransactionsOverviewLoading());
      return emit.forEach(
        _repository.getAll(event.filter.type),
        onData: (data) => TransactionsOverviewSuccess(data),
      );
    });
  }

  final TransactionRepository _repository;
}
