import 'dart:developer';

import 'package:expenses_copilot_app/categories/presentation/widgets/expenses_categories_dropdown.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/expenses/providers/create_expense/create_expense_cubit.dart';
import 'package:expenses_copilot_app/payment_methods/presentation/widgets/payment_methods_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CreateExpenseScreen extends StatelessWidget {
  static const routeName = '/expenses/create';
  const CreateExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateExpenseCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: const CreateExpenseForm(),
        bottomNavigationBar: CustomBottomAppBar(
            child: FilledButton(
          onPressed: () {},
          child: const Text('Agregar gasto'),
        )),
      ),
    );
  }
}

class CreateExpenseForm extends StatelessWidget {
  const CreateExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Agrega un nuevo gasto',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(10),
          const Text(
              'Agrega los detalles de tú gasto que te ayudara a mantener registro de tus gastos'),
          const Gap(20),
          CustomInputField(
            isRequired: true,
            title: 'Valor',
            child: CustomNumberFormField(
              fieldSettings: const TextFieldSettings(
                textInputType: TextInputType.number,
              ),
              onChanged: context.read<CreateExpenseCubit>().onChangeValue,
              text: context.read<CreateExpenseCubit>().state.value,
            ),
          ),
          const Gap(10),
          CustomInputField(
            isRequired: true,
            title: 'Descripción',
            child: CustomTextFormField(
              onChanged: context.read<CreateExpenseCubit>().onChangeName,
              fieldSettings:
                  const TextFieldSettings(textInputType: TextInputType.text),
              text: context.read<CreateExpenseCubit>().state.name,
            ),
          ),
          const Gap(10),
          CustomInputField(
            isRequired: true,
            title: 'Categoría',
            child: ExpensesCategoriesDropdownBuilder(
              onChanged: context.read<CreateExpenseCubit>().onChangeCategory,
            ),
          ),
          const Gap(10),
          CustomInputField(
            isRequired: true,
            title: 'Método de pago',
            child: PaymentMethodsDropdownBuilder(
              onChanged:
                  context.read<CreateExpenseCubit>().onChangePaymentMethod,
            ),
          ),
          const Gap(10),
          const CustomInputField(
            title: 'Fecha',
            child: CrateExpenseDateInput(),
          ),
        ],
      ),
    );
  }
}

class CrateExpenseDateInput extends StatefulWidget {
  const CrateExpenseDateInput({
    super.key,
  });

  @override
  State<CrateExpenseDateInput> createState() => _CrateExpenseDateInputState();
}

class _CrateExpenseDateInputState extends State<CrateExpenseDateInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text =
        context.read<CreateExpenseCubit>().state.date.toIso8601String();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseCubit, CreateExpenseState>(
        listenWhen: (previous, current) => previous.date != current.date,
        listener: (context, state) {
          _controller.text = state.date.toIso8601String();
        },
        child: TextFormField(
          controller: _controller,
          readOnly: true,
          onTap: () {
            showDatePicker(
              initialDate: context.read<CreateExpenseCubit>().state.date,
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            ).then(context.read<CreateExpenseCubit>().onChangeDate);
          },
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.calendar_month,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
