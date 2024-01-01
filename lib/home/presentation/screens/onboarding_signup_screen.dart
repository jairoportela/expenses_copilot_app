import 'package:authentication_repository/authentication_repository.dart';
import 'package:crud_repository/crud_repository.dart';
import 'package:expenses_copilot_app/authentication/providers/app_bloc/app_bloc.dart';
import 'package:expenses_copilot_app/categories/data/repositories/category_repository.dart';
import 'package:expenses_copilot_app/common/widgets/app_bottom_bar.dart';
import 'package:expenses_copilot_app/home/providers/cubit/sign_up_onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gap/gap.dart';

List<CategorySelectableItem> expensesCategories = [
  const CategorySelectableItem(
    '1',
    'Alimentación',
    Icons.restaurant_menu_rounded,
  ),
  const CategorySelectableItem(
    '2',
    'Transporte',
    Icons.airport_shuttle_rounded,
  ),
  const CategorySelectableItem(
    '3',
    'Vivienda',
    Icons.home,
  ),
  const CategorySelectableItem(
    '4',
    'Entretenimiento',
    Icons.movie_creation_rounded,
  ),
  const CategorySelectableItem(
    '5',
    'Salud',
    Icons.health_and_safety,
  ),
  const CategorySelectableItem(
    '6',
    'Educación',
    Icons.school,
  ),
  const CategorySelectableItem(
    '7',
    'Deudas',
    Icons.payments_rounded,
  ),
  const CategorySelectableItem(
    '8',
    'Impuestos',
    Icons.account_balance_rounded,
  ),
  const CategorySelectableItem(
    '9',
    'Trabajo',
    Icons.work,
  ),
];
List<CategorySelectableItem> incomesCategories = [
  const CategorySelectableItem(
    '1',
    'Salario',
    Icons.monetization_on,
  ),
  const CategorySelectableItem(
    '2',
    'Prestamos',
    Icons.car_crash,
  ),
  const CategorySelectableItem(
    '3',
    'Inversiones',
    Icons.inventory,
  ),
];

class OnboardingSignUpScreen extends StatelessWidget {
  static const routeName = '/onboarding-signup';
  const OnboardingSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignUpOnboardingCubit(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
            repository: CategoryRepositoryImplementation(
              dataSource: RepositoryProvider.of<CrudRepository>(context),
            )),
        child: const Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: OnboardingView(),
            ),
          ),
          bottomNavigationBar: CustomBottomAppBar(
            child: ChangeStepOnboardingButton(),
          ),
        ));
  }
}

class ChangeStepOnboardingButton extends StatelessWidget {
  const ChangeStepOnboardingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpOnboardingCubit, SignUpOnboardingState>(
      listener: (context, state) {
        if (state.stepError != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(
                state.stepError!,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
        }
      },
      builder: (context, state) {
        final step = state.step;
        final status = state.status;
        if (step == SignUpOnboardingStep.selectExpensesCategories) {
          return FilledButton(
            onPressed: () {
              if (step == SignUpOnboardingStep.selectExpensesCategories) {
                context
                    .read<SignUpOnboardingCubit>()
                    .incomesCategoriesStepChanged();
              }
            },
            child: const Text('Siguiente'),
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (step == SignUpOnboardingStep.selectIncomesCategories) {
                      context.read<SignUpOnboardingCubit>().goBackToExpenses();
                    }
                  },
                  child: const Text('Atrás'),
                ),
              ),
              const Gap(10),
              Expanded(
                child: status is FormSubmitLoading
                    ? FilledButton.icon(
                        icon: Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        ),
                        onPressed: null,
                        label: const Text('Finalizar'),
                      )
                    : FilledButton(
                        onPressed: () {
                          if (step ==
                              SignUpOnboardingStep.selectIncomesCategories) {
                            context
                                .read<SignUpOnboardingCubit>()
                                .submitFinishOnboarding(
                                    context.read<AppBloc>().state.user.id);
                          }
                        },
                        child: const Text('Finalizar'),
                      ),
              ),
            ],
          );
        }
      },
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpOnboardingCubit, SignUpOnboardingState>(
      builder: (context, state) {
        if (state.step == SignUpOnboardingStep.selectExpensesCategories) {
          return Column(
            children: [
              const Gap(20),
              Text(
                'Selecciona las categorías de tus gastos, luego podras editarlas',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(20),
              Expanded(
                  child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final item = expensesCategories[index];
                  return SelectableCardCategory(
                    initialValue: state.expensesCategories.containsKey(item.id),
                    key: Key('expense-category-${item.id}'),
                    icon: item.icon,
                    title: item.name,
                    onSelected: () {
                      context
                          .read<SignUpOnboardingCubit>()
                          .onExpenseCategoryChange(item.id, item);
                    },
                  );
                },
                itemCount: expensesCategories.length,
              )),
              const Gap(20),
            ],
          );
        } else if (state.step == SignUpOnboardingStep.selectIncomesCategories) {
          return Column(
            children: [
              const Gap(20),
              Text(
                'Selecciona las categorías de tus ingresos, luego podras editarlas',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(20),
              Expanded(
                  child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final item = incomesCategories[index];
                  return SelectableCardCategory(
                    initialValue: state.incomesCategories.containsKey(item.id),
                    key: Key('income-category-${item.id}'),
                    icon: item.icon,
                    title: item.name,
                    onSelected: () {
                      context
                          .read<SignUpOnboardingCubit>()
                          .onIncomeCategoryChange(item.id, item);
                    },
                  );
                },
                itemCount: incomesCategories.length,
              )),
              const Gap(20),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class SelectableCardCategory extends StatefulWidget {
  const SelectableCardCategory({
    super.key,
    required this.icon,
    required this.title,
    required this.initialValue,
    required this.onSelected,
  });
  final String title;
  final IconData icon;
  final bool initialValue;
  final Function() onSelected;

  @override
  State<SelectableCardCategory> createState() => _SelectableCardCategoryState();
}

class _SelectableCardCategoryState extends State<SelectableCardCategory> {
  bool _isSelected = false;

  void onChangeState() {
    setState(() {
      _isSelected = !_isSelected;
    });
    widget.onSelected();
  }

  @override
  void initState() {
    _isSelected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onChangeState,
      child: Card(
        color: _isSelected ? const Color.fromARGB(181, 96, 125, 139) : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  maxLines: 2,
                ),
              ),
              const Gap(10),
              Center(
                child: Icon(
                  widget.icon,
                  size: 40,
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
