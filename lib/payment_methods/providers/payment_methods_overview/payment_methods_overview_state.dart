part of 'payment_methods_overview_cubit.dart';

sealed class PaymentMethodsOverviewState extends Equatable {
  const PaymentMethodsOverviewState();

  @override
  List<Object> get props => [];
}

final class PaymentMethodsOverviewInitial extends PaymentMethodsOverviewState {}

final class PaymentMethodsOverviewLoading extends PaymentMethodsOverviewState {}

final class PaymentMethodsOverviewSuccess extends PaymentMethodsOverviewState {
  const PaymentMethodsOverviewSuccess(this.data);
  final List<PaymentMethod> data;
}

final class PaymentMethodsOverviewError extends PaymentMethodsOverviewState {}
