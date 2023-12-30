import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/categories/presentation/widgets/categories_dropdown.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/incomes/data/models/income.dart';
import 'package:expenses_copilot_app/incomes/data/repository/income_repository.dart';
import 'package:expenses_copilot_app/incomes/presentation/widgets/create_income_submit_button.dart';
import 'package:expenses_copilot_app/incomes/providers/create_income/create_income_cubit.dart';
import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gap/gap.dart';
import 'package:query_repository/query_repository.dart';

class CreateIncomeArguments {
  const CreateIncomeArguments({
    required this.toEditIncome,
  });
  final Income? toEditIncome;
}

class CreateIncomeScreen extends StatelessWidget {
  static const routeName = '/incomes/create';
  const CreateIncomeScreen({super.key, this.initialIncome});
  final CreateIncomeArguments? initialIncome;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateIncomeCubit(
        income: initialIncome?.toEditIncome,
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
        body: CreateIncomeForm(
          isEditing: initialIncome?.toEditIncome != null,
        ),
        bottomNavigationBar: CustomBottomAppBar(
          child: CreateIncomeSubmitButton(
            isEditing: initialIncome?.toEditIncome != null,
          ),
        ),
      ),
    );
  }
}

class CreateIncomeForm extends StatelessWidget {
  const CreateIncomeForm({super.key, required this.isEditing});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? 'Edita el ingreso' : 'Agrega un nuevo ingreso',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(10),
          if (!isEditing)
            const Text(
                'Agrega los detalles del nuevo ingreso que te ayudara a mantener registro de tus finanzas'),
          const Gap(20),
          const CreateIncomeValueInput(),
          const Gap(10),
          const CreateIncomeDescriptionInput(),
          const Gap(10),
          const CreateIncomeCategoryInput(),
          const Gap(10),
          const CustomInputField(
            title: 'Fecha',
            child: CrateIncomeDateInput(),
          ),
        ],
      ),
    );
  }
}

class CreateIncomeCategoryInput extends StatelessWidget {
  const CreateIncomeCategoryInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final id = context.read<CreateIncomeCubit>().state.categoryId.value;
    return BlocSelector<CreateIncomeCubit, CreateIncomeState, TextInputValue>(
      selector: (state) {
        return state.categoryId;
      },
      builder: (context, value) {
        return CustomInputField(
          isRequired: true,
          title: 'Categoría',
          child: CategoriesDropdownBuilder(
            initialId: id,
            type: CategoryType.income,
            text: value,
            onChanged: context.read<CreateIncomeCubit>().onChangeCategory,
          ),
        );
      },
    );
  }
}

class CreateIncomeDescriptionInput extends StatefulWidget {
  const CreateIncomeDescriptionInput({
    super.key,
  });

  @override
  State<CreateIncomeDescriptionInput> createState() =>
      _CreateIncomeDescriptionInputState();
}

class _CreateIncomeDescriptionInputState
    extends State<CreateIncomeDescriptionInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context.read<CreateIncomeCubit>().state.name.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateIncomeCubit, CreateIncomeState, TextInputValue>(
      selector: (state) {
        return state.name;
      },
      builder: (context, value) {
        return CustomInputField(
          isRequired: true,
          title: 'Descripción',
          child: CustomTextFormField(
            controller: _controller,
            onChanged: context.read<CreateIncomeCubit>().onChangeName,
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

class CreateIncomeValueInput extends StatefulWidget {
  const CreateIncomeValueInput({
    super.key,
  });

  @override
  State<CreateIncomeValueInput> createState() => _CreateIncomeValueInputState();
}

class _CreateIncomeValueInputState extends State<CreateIncomeValueInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context.read<CreateIncomeCubit>().state.value.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateIncomeCubit, CreateIncomeState, NumberInputValue>(
      selector: (state) {
        return state.value;
      },
      builder: (context, value) {
        return CustomInputField(
          isRequired: true,
          title: 'Valor',
          child: CustomCurrencyFormField(
            controller: _controller,
            fieldSettings: const TextFieldSettings(
              textInputType: TextInputType.number,
            ),
            onChanged: context.read<CreateIncomeCubit>().onChangeValue,
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

class CrateIncomeDateInput extends StatefulWidget {
  const CrateIncomeDateInput({
    super.key,
  });

  @override
  State<CrateIncomeDateInput> createState() => _CrateIncomeDateInputState();
}

class _CrateIncomeDateInputState extends State<CrateIncomeDateInput> {
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
