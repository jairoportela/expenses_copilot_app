import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/categories/presentation/widgets/categories_dropdown.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/expenses/data/models/expense.dart';
import 'package:expenses_copilot_app/expenses/data/repository/expenses_repository.dart';
import 'package:expenses_copilot_app/expenses/presentation/screens/widgets/create_expense_submit_button.dart';
import 'package:expenses_copilot_app/expenses/providers/create_expense/create_expense_cubit.dart';
import 'package:expenses_copilot_app/payment_methods/presentation/widgets/payment_methods_dropdown.dart';
import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gap/gap.dart';
import 'package:query_repository/query_repository.dart';

class CreateExpenseArguments {
  const CreateExpenseArguments({
    required this.toEditExpense,
  });
  final Expense? toEditExpense;
}

class CreateExpenseScreen extends StatelessWidget {
  static const routeName = '/expenses/create';
  const CreateExpenseScreen({super.key, this.initialExpense});
  final CreateExpenseArguments? initialExpense;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateExpenseCubit(
        expense: initialExpense?.toEditExpense,
        repository: ExpensesRepositoryImplementation(
          dataSource: RepositoryProvider.of<QueryRepository>(context),
        ),
        userId: context.read<AppBloc>().state.user.id,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: CreateExpenseForm(
          isEditing: initialExpense?.toEditExpense != null,
        ),
        bottomNavigationBar: CustomBottomAppBar(
          child: CreateExpenseSubmitButton(
            isEditing: initialExpense?.toEditExpense != null,
          ),
        ),
      ),
    );
  }
}

class CreateExpenseForm extends StatelessWidget {
  const CreateExpenseForm({super.key, required this.isEditing});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? 'Edita tu gasto' : 'Agrega un nuevo gasto',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(10),
          if (!isEditing)
            const Text(
                'Agrega los detalles de tú gasto que te ayudara a mantener registro de tus gastos'),
          const Gap(20),
          const CreateExpenseValueInput(),
          const Gap(10),
          const CreateExpenseDescriptionInput(),
          const Gap(10),
          const CreateExpenseCategoryInput(),
          const Gap(10),
          const CreateExpensePaymentMethodInput(),
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

class CreateExpensePaymentMethodInput extends StatelessWidget {
  const CreateExpensePaymentMethodInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final id = context.read<CreateExpenseCubit>().state.paymentMethodId.value;
    return BlocSelector<CreateExpenseCubit, CreateExpenseState, TextInputValue>(
      selector: (state) {
        return state.paymentMethodId;
      },
      builder: (context, value) {
        return CustomInputField(
          isRequired: true,
          title: 'Método de pago',
          child: PaymentMethodsDropdownBuilder(
            initialId: id.isEmpty ? null : id,
            text: value,
            onChanged: context.read<CreateExpenseCubit>().onChangePaymentMethod,
          ),
        );
      },
    );
  }
}

class CreateExpenseCategoryInput extends StatelessWidget {
  const CreateExpenseCategoryInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final id = context.read<CreateExpenseCubit>().state.categoryId.value;
    return BlocSelector<CreateExpenseCubit, CreateExpenseState, TextInputValue>(
      selector: (state) {
        return state.categoryId;
      },
      builder: (context, value) {
        return CustomInputField(
          isRequired: true,
          title: 'Categoría',
          child: CategoriesDropdownBuilder(
            initialId: id.isEmpty ? null : id,
            type: CategoryType.expense,
            text: value,
            onChanged: context.read<CreateExpenseCubit>().onChangeCategory,
          ),
        );
      },
    );
  }
}

class CreateExpenseDescriptionInput extends StatefulWidget {
  const CreateExpenseDescriptionInput({
    super.key,
  });

  @override
  State<CreateExpenseDescriptionInput> createState() =>
      _CreateExpenseDescriptionInputState();
}

class _CreateExpenseDescriptionInputState
    extends State<CreateExpenseDescriptionInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context.read<CreateExpenseCubit>().state.name.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateExpenseCubit, CreateExpenseState, TextInputValue>(
      selector: (state) {
        return state.name;
      },
      builder: (context, value) {
        return CustomInputField(
          isRequired: true,
          title: 'Descripción',
          child: CustomTextFormField(
            controller: _controller,
            onChanged: context.read<CreateExpenseCubit>().onChangeName,
            fieldSettings:
                const TextFieldSettings(textInputType: TextInputType.text),
            text: value,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CreateExpenseValueInput extends StatefulWidget {
  const CreateExpenseValueInput({
    super.key,
  });

  @override
  State<CreateExpenseValueInput> createState() =>
      _CreateExpenseValueInputState();
}

class _CreateExpenseValueInputState extends State<CreateExpenseValueInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context.read<CreateExpenseCubit>().state.value.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateExpenseCubit, CreateExpenseState,
        NumberInputValue>(
      selector: (state) {
        return state.value;
      },
      builder: (context, value) {
        return CustomInputField(
          isRequired: true,
          title: 'Valor',
          child: CustomNumberFormField(
            controller: _controller,
            fieldSettings: const TextFieldSettings(
              textInputType: TextInputType.number,
            ),
            onChanged: context.read<CreateExpenseCubit>().onChangeValue,
            text: value,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        getDateText(context.read<CreateExpenseCubit>().state.date);
    super.initState();
  }

  String getDateText(DateTime date) {
    return date.yMMMd();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseCubit, CreateExpenseState>(
        listenWhen: (previous, current) => previous.date != current.date,
        listener: (context, state) {
          _controller.text = getDateText(state.date);
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
