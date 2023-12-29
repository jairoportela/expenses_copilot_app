import 'dart:developer';

import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/common/widgets/number_icon.dart';
import 'package:expenses_copilot_app/expenses/data/models/expense.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/create_expense_screen.dart';
import 'package:expenses_copilot_app/incomes/presentation/screens/create_income_screen.dart';
import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:expenses_copilot_app/transactions/providers/transaction_detail/transaction_detail_cubit.dart';
import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:expenses_copilot_app/utils/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class TransactionDetailArguments {
  const TransactionDetailArguments({
    required this.id,
    required this.type,
    required this.iconData,
    required this.title,
  });
  final String id;
  final CategoryType type;
  final int? iconData;
  final String title;
}

class TransactionDetailScreen extends StatelessWidget {
  static const routeName = '/transaction-detail';
  const TransactionDetailScreen({
    super.key,
    required this.arguments,
  });
  final TransactionDetailArguments arguments;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = ElevationOverlay.applySurfaceTint(
        colorScheme.surface, colorScheme.surfaceTint, 1);
    var TransactionDetailArguments(:iconData, :id, :title, :type) = arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del movimiento'),
        centerTitle: true,
        actions: [
          BlocSelector<TransactionDetailCubit, TransactionDetailState,
              Transaction?>(
            selector: (state) {
              return state.data;
            },
            builder: (context, transaction) {
              if (transaction != null) {
                return IconButton(
                  onPressed: () {
                    if (type == CategoryType.expense) {
                      Navigator.of(context)
                          .pushNamed(
                        CreateExpenseScreen.routeName,
                        arguments: CreateExpenseArguments(
                          toEditExpense: transaction as Expense,
                        ),
                      )
                          .then((value) {
                        if (value == true) {
                          context.read<TransactionDetailCubit>().getTransaction(
                                id,
                                type,
                              );
                        }
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(CreateIncomeScreen.routeName);
                    }
                  },
                  icon: const Icon(Icons.edit),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocSelector<TransactionDetailCubit, TransactionDetailState,
                Transaction?>(
              selector: (state) {
                return state.data;
              },
              builder: (context, transaction) {
                double? value;
                if (transaction != null) {
                  Transaction(:value) = transaction;
                  if (type == CategoryType.expense) value *= -1;
                }

                return TransactionTitleCard(
                  color: color,
                  title: transaction?.name ?? title,
                  id: id,
                  iconData: transaction?.category.icon ?? iconData,
                  value: value,
                );
              },
            ),
            const Gap(5),
            const TransactionInfoColumn(),
          ],
        ),
      ),
    );
  }
}

class TransactionInfoColumn extends StatelessWidget {
  const TransactionInfoColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDetailCubit, TransactionDetailState>(
      builder: (context, state) {
        log(state.toString(), name: 'TransactionDetailCubit');
        if (state.status == TransactionDetailStatus.loading ||
            state.status == TransactionDetailStatus.initial) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final data = state.data;
        if (data == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Un error a ocurrido'),
            ),
          );
        }

        var Transaction(:category, :date, :type) = data;
        PaymentMethod? paymentMethod;
        if (data is Expense) Expense(:paymentMethod) = data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoTransactionCard.fromDate(
              title: 'Fecha',
              data: date,
            ),
            const Gap(5),
            InfoTransactionCard.fromText(
              title: 'Categoría',
              data: category.name,
            ),
            const Gap(5),
            if (type == CategoryType.expense && paymentMethod != null)
              InfoTransactionCard.fromText(
                title: 'Método de pago',
                data: paymentMethod.name,
              )
          ],
        );
      },
    );
  }
}

class TransactionTitleCard extends StatelessWidget {
  const TransactionTitleCard({
    super.key,
    required this.color,
    required this.title,
    required this.id,
    required this.iconData,
    required this.value,
  });

  final Color color;
  final String title;

  final String id;
  final int? iconData;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: const ShapeDecoration(
                  color: Color.fromARGB(255, 159, 223, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: ShapeDecoration(
                  color: color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Gap(5),
                    if (value != null)
                      Text(
                        value!.toCOPFormatWithSign(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: value! > 0 ? Colors.greenAccent : null,
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (iconData != null)
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Hero(
              tag: 'icon-$id',
              child: Icon(
                NumberIcons.getIconByNumber(iconData!),
                color: Colors.white,
                size: 30,
              ),
            ),
          )
      ]),
    );
  }
}

class InfoTransactionCard extends StatelessWidget {
  const InfoTransactionCard.fromText({
    super.key,
    required this.title,
    required String data,
  }) : _data = data;

  InfoTransactionCard.fromNumber({
    super.key,
    required this.title,
    required double data,
  }) : _data = data.toCOPFormatWithSign();
  InfoTransactionCard.fromDate({
    super.key,
    required this.title,
    required DateTime data,
  }) : _data = data.yMMMd();

  final String title;
  final String _data;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(10),
              Flexible(
                child: Text(
                  _data,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            ],
          ),
        ));
  }
}
