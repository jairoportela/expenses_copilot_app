import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:expenses_copilot_app/transactions/data/repository/transaction_repository.dart';

part 'transaction_detail_state.dart';

class TransactionDetailCubit extends Cubit<TransactionDetailState> {
  TransactionDetailCubit({required TransactionRepository repository})
      : _repository = repository,
        super(TransactionDetailState.empty);

  void getTransaction(String id, CategoryType type) async {
    try {
      emit(state.copyWith(status: TransactionDetailStatus.loading));
      final data = await _repository.getOne(categoryType: type, id: id);
      emit(state.copyWith(
        status: TransactionDetailStatus.success,
        data: () => data,
      ));
    } catch (error) {
      emit(state.copyWith(status: TransactionDetailStatus.error));
    }
  }

  final TransactionRepository _repository;
}
