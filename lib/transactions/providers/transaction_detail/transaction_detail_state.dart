part of 'transaction_detail_cubit.dart';

enum TransactionDetailStatus {
  initial,
  loading,
  success,
  error,
}

class TransactionDetailState extends Equatable {
  const TransactionDetailState(this.status, this.data);
  final TransactionDetailStatus status;
  final Transaction? data;

  static const TransactionDetailState empty =
      TransactionDetailState(TransactionDetailStatus.initial, null);

  TransactionDetailState copyWith({
    TransactionDetailStatus? status,
    Transaction? Function()? data,
  }) {
    return TransactionDetailState(
      status ?? this.status,
      data != null ? data() : this.data,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
