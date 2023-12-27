import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/categories/presentation/widgets/categories_dropdown.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/incomes/data/repository/income_repository.dart';
import 'package:expenses_copilot_app/incomes/presentation/widgets/create_income_submit_button.dart';
import 'package:expenses_copilot_app/incomes/providers/create_income/create_income_cubit.dart';
import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gap/gap.dart';
import 'package:query_repository/query_repository.dart';

class CreateIncomeScreen extends StatelessWidget {
  static const routeName = '/incomes/create';
  const CreateIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateIncomeCubit(
        repository: IncomeRepositoryImplementation(
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
        body: const CreateIncomeForm(),
        bottomNavigationBar: const CustomBottomAppBar(
          child: CreateIncomeSubmitButton(),
        ),
      ),
    );
  }
}

class CreateIncomeForm extends StatelessWidget {
  const CreateIncomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Agrega un nuevo ingreso',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(10),
          const Text(
              'Agrega los detalles del nuevo ingreso que te ayudara a mantener registro de tus finanzas'),
          const Gap(20),
          BlocSelector<CreateIncomeCubit, CreateIncomeState, NumberInputValue>(
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
                  onChanged: context.read<CreateIncomeCubit>().onChangeValue,
                  text: value,
                ),
              );
            },
          ),
          const Gap(10),
          BlocSelector<CreateIncomeCubit, CreateIncomeState, TextInputValue>(
            selector: (state) {
              return state.name;
            },
            builder: (context, value) {
              return CustomInputField(
                isRequired: true,
                title: 'Descripción',
                child: CustomTextFormField(
                  onChanged: context.read<CreateIncomeCubit>().onChangeName,
                  fieldSettings: const TextFieldSettings(
                      textInputType: TextInputType.text),
                  text: value,
                ),
              );
            },
          ),
          const Gap(10),
          BlocSelector<CreateIncomeCubit, CreateIncomeState, TextInputValue>(
            selector: (state) {
              return state.categoryId;
            },
            builder: (context, value) {
              return CustomInputField(
                isRequired: true,
                title: 'Categoría',
                child: CategoriesDropdownBuilder(
                  type: CategoryType.income,
                  text: value,
                  onChanged: context.read<CreateIncomeCubit>().onChangeCategory,
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
        getDateText(context.read<CreateIncomeCubit>().state.date);
    super.initState();
  }

  String getDateText(DateTime date) {
    return date.yMMMd();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateIncomeCubit, CreateIncomeState>(
        listenWhen: (previous, current) => previous.date != current.date,
        listener: (context, state) {
          _controller.text = getDateText(state.date);
        },
        child: TextFormField(
          controller: _controller,
          readOnly: true,
          onTap: () {
            showDatePicker(
              initialDate: context.read<CreateIncomeCubit>().state.date,
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            ).then(context.read<CreateIncomeCubit>().onChangeDate);
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
