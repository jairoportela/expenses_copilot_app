import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
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
              child: DropdownButtonFormField(
                borderRadius: BorderRadius.circular(20),
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                ),
                items: [
                  const DropdownMenuItem(
                    child: Row(children: [
                      Icon(Icons.pool),
                      Gap(10),
                      Text('Natación')
                    ]),
                    value: 'a',
                  ),
                  const DropdownMenuItem(
                    child: Text('Compras'),
                    value: 'b',
                  ),
                  const DropdownMenuItem(
                    child: Text('Baile'),
                    value: 'c',
                  )
                ],
                onChanged: (value) {},
              ),
            ),
            const Gap(10),
            CustomInputField(
              title: 'Método de pago',
              child: DropdownButtonFormField(
                borderRadius: BorderRadius.circular(20),
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                ),
                items: [
                  const DropdownMenuItem(
                    child: Text('Rappi'),
                    value: 'rappi',
                  ),
                  const DropdownMenuItem(
                    child: Text('Bancolombia'),
                    value: 'bancolombia',
                  ),
                  const DropdownMenuItem(
                    child: Text('Nubank'),
                    value: 'nubank',
                  )
                ],
                onChanged: (value) {},
              ),
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
