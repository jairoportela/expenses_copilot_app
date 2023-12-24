import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';
import 'package:expenses_copilot_app/payment_methods/providers/payment_methods_overview/payment_methods_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:query_repository/query_repository.dart';

class PaymentMethodsDropdownBuilder extends StatelessWidget {
  const PaymentMethodsDropdownBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentMethodsOverviewCubit(
        repository: SupabaseQueryRepository(),
      )..getData(),
      child: const PaymentMethodsDropdown(),
    );
  }
}

class PaymentMethodsDropdown extends StatelessWidget {
  const PaymentMethodsDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodsOverviewCubit,
        PaymentMethodsOverviewState>(
      builder: (context, state) {
        final List<PaymentMethod> data = switch (state) {
          PaymentMethodsOverviewSuccess() => state.data,
          _ => [],
        };
        return DropdownButtonFormField(
          selectedItemBuilder: (context) {
            return data.map((PaymentMethod item) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: 100,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.7),
                child: FittedBox(
                  child: Text(
                    item.name,
                    maxLines: 2,
                  ),
                ),
              );
            }).toList();
          },
          borderRadius: BorderRadius.circular(20),
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
          ),
          items: [
            for (var paymentMethod in data)
              DropdownMenuItem(
                value: paymentMethod.id,
                child: Flexible(
                    child: Text(
                  paymentMethod.name,
                  maxLines: 2,
                )),
              ),
          ],
          onChanged: (value) {},
        );
      },
    );
  }
}
