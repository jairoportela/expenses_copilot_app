import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/categories/presentation/widgets/categories_dropdown.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
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

class CreateExpenseScreen extends StatelessWidget {
  static const routeName = '/expenses/create';
  const CreateExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateExpenseCubit(
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
        body: const CreateExpenseForm(),
        bottomNavigationBar: const CustomBottomAppBar(
          child: CreateExpenseSubmitButton(),
        ),
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
          BlocSelector<CreateExpenseCubit, CreateExpenseState,
              NumberInputValue>(
            selector: (state) {
              return state.value;
            },
            builder: (context, value) {
              return CustomInputField(
                isRequired: true,
                title: 'Valor',
                child: CustomNumberFormField(
                  fieldSettings: const TextFieldSettings(
                    textInputType: TextInputType.number,
                  ),
                  onChanged: context.read<CreateExpenseCubit>().onChangeValue,
                  text: value,
                ),
              );
            },
          ),
          const Gap(10),
          BlocSelector<CreateExpenseCubit, CreateExpenseState, TextInputValue>(
            selector: (state) {
              return state.name;
            },
            builder: (context, value) {
              return CustomInputField(
                isRequired: true,
                title: 'Descripción',
                child: CustomTextFormField(
                  onChanged: context.read<CreateExpenseCubit>().onChangeName,
                  fieldSettings: const TextFieldSettings(
                      textInputType: TextInputType.text),
                  text: value,
                ),
              );
            },
          ),
          const Gap(10),
          BlocSelector<CreateExpenseCubit, CreateExpenseState, TextInputValue>(
            selector: (state) {
              return state.categoryId;
            },
            builder: (context, value) {
              return CustomInputField(
                isRequired: true,
                title: 'Categoría',
                child: CategoriesDropdownBuilder(
                  type: CategoryType.expense,
                  text: value,
                  onChanged:
                      context.read<CreateExpenseCubit>().onChangeCategory,
                ),
              );
            },
          ),
          const Gap(10),
          BlocSelector<CreateExpenseCubit, CreateExpenseState, TextInputValue>(
            selector: (state) {
              return state.paymentMethodId;
            },
            builder: (context, value) {
              return CustomInputField(
                isRequired: true,
                title: 'Método de pago',
                child: PaymentMethodsDropdownBuilder(
                  text: value,
                  onChanged:
                      context.read<CreateExpenseCubit>().onChangePaymentMethod,
                ),
              );
            },
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
