import 'package:expenses_copilot_app/expenses/providers/create_expense/create_expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';

class CreateExpenseSubmitButton extends StatelessWidget {
  const CreateExpenseSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateExpenseCubit, CreateExpenseState>(
      listener: (context, state) {
        final status = state.status;
        if (status is FormSubmitSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
              content: Text(
                'Gasto creado con exito ✅',
              ),
            ));

          Navigator.of(context).pop();
        }
        if (status is FormSubmitError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(
                status.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final status = state.status;
        if (status is FormSubmitLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return FilledButton(
          onPressed: context.read<CreateExpenseCubit>().onSubmit,
          child: const Text('Agregar gasto'),
        );
      },
    );
  }
}
