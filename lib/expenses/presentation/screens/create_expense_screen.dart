import 'package:expenses_copilot_app/categories/presentation/widgets/expenses_categories_dropdown.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/payment_methods/presentation/widgets/payment_methods_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateExpenseScreen extends StatelessWidget {
  static const routeName = '/expenses/create';
  const CreateExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class CreateExpenseForm extends StatelessWidget {
  const CreateExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
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
              title: 'Valor *',
              child: TextFormField(),
            ),
            const Gap(10),
            CustomInputField(
              title: 'Descripción *',
              child: TextFormField(),
            ),
            const Gap(10),
            CustomInputField(
              title: 'Categoría *',
              child: ExpensesCategoriesDropdownBuilder(),
            ),
            const Gap(10),
            CustomInputField(
              title: 'Método de pago *',
              child: PaymentMethodsDropdownBuilder(),
            ),
            const Gap(10),
            CustomInputField(
              title: 'Fecha',
              child: TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.calendar_month,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
