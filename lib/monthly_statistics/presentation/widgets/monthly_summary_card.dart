import 'package:expenses_copilot_app/monthly_statistics/data/models/monthly_summary.dart';
import 'package:expenses_copilot_app/monthly_statistics/data/repositories/monthly_summary_repository.dart';
import 'package:expenses_copilot_app/monthly_statistics/provider/bloc/monthly_summary_bloc.dart';

import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:expenses_copilot_app/utils/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:crud_repository/crud_repository.dart';

class MonthlySummaryBuilder extends StatelessWidget {
  const MonthlySummaryBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocProvider(
      create: (context) => MonthlySummaryBloc(
        repository: MonthlySummaryRepositoryImplementation(
          dataSource: RepositoryProvider.of<CrudRepository>(context),
        ),
      )..add(ListenMonthlySummaryEvent(DateTime(now.year, now.month, 1))),
      child: Builder(builder: (context) {
        return BlocBuilder<MonthlySummaryBloc, MonthlySummaryState>(
          builder: (context, state) {
            if (state is MonthlySummarySuccess) {
              return MonthlySummaryCard(data: state.data);
            } else {
              return const Center(
                child: LinearProgressIndicator(),
              );
            }
          },
        );
      }),
    );
  }
}

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    super.key,
    required this.data,
  });
  final MonthlySummary data;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(26, 63, 101, 0.187).withOpacity(0.1),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Tu plata en ${data.month.monthText()}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ingresos'),
              Text(
                data.totalIncomes.toCOPFormatWithSign(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.greenAccent),
              ),
            ],
          ),
          const Gap(8),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(10),
            value: data.incomesPercentage,
            color: Colors.greenAccent,
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gastos'),
              Text(
                data.totalExpenses.toCOPFormatWithSign(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const Gap(8),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(10),
            value: data.expensesPercentage,
            color: Colors.blueGrey,
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Balance'),
              Text(
                data.balance.toCOPFormatWithSign(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
