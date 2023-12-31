import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/transactions/data/repository/transaction_repository.dart';

part 'delete_transaction_state.dart';

class DeleteTransactionCubit extends Cubit<DeleteTransactionState> {
  DeleteTransactionCubit({required TransactionRepository repository})
      : _repository = repository,
        super(DeleteTransactionInitial());

  void onDeleteTransaction(String id, CategoryType type) async {
    try {
      emit(DeleteTransactionLoading());
      await _repository.delete(categoryType: type, id: id);
      emit(DeleteTransactionSuccess());
    } catch (error) {
      emit(DeleteTransactionError());
    }
  }

  final TransactionRepository _repository;
}
