import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/payment_methods/data/models/payment_method.dart';
import 'package:expenses_copilot_app/payment_methods/providers/payment_methods_overview/payment_methods_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:crud_repository/crud_repository.dart';

class PaymentMethodsDropdownBuilder extends StatelessWidget {
  const PaymentMethodsDropdownBuilder({
    super.key,
    required this.onChanged,
    required this.text,
    this.initialId,
  });
  final void Function(String? value)? onChanged;
  final TextInputValue text;
  final String? initialId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentMethodsOverviewCubit(
        repository: RepositoryProvider.of<CrudRepository>(context),
      )..getData(),
      child: PaymentMethodsDropdown(
        onChanged: onChanged,
        text: text,
        initialId: initialId,
      ),
    );
  }
}

class PaymentMethodsDropdown extends StatelessWidget {
  const PaymentMethodsDropdown({
    super.key,
    required this.onChanged,
    required this.text,
    required this.initialId,
  });
  final void Function(String? value)? onChanged;
  final TextInputValue text;
  final String? initialId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodsOverviewCubit,
        PaymentMethodsOverviewState>(
      builder: (context, state) {
        final List<PaymentMethod> data = switch (state) {
          PaymentMethodsOverviewSuccess() => state.data,
          _ => [],
        };

        String? id;
        try {
          id = data.firstWhere((value) => value.id == initialId).id;
        } catch (_) {}

        return StringDropdownFormField(
          initialValue: id,
          text: text,
          onChanged: onChanged,
          selectedItemBuilder: (context) {
            return data.map((PaymentMethod item) {
              return Container(
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(
                    minWidth: 100,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.7),
                child: FittedBox(
                  child: Text(
                    item.name,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                ),
              );
            }).toList();
          },
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
          items: [
            for (var paymentMethod in data)
              DropdownMenuItem(
                value: paymentMethod.id,
                child: FittedBox(
                    child: Text(
                  paymentMethod.name,
                  maxLines: 2,
                )),
              ),
          ],
        );
      },
    );
  }
}
