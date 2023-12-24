import 'package:expenses_copilot_app/categories/data/models/expense_category.dart';
import 'package:expenses_copilot_app/categories/providers/expenses_categories_overview/expenses_categories_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:query_repository/query_repository.dart';

class ExpensesCategoriesDropdownBuilder extends StatelessWidget {
  const ExpensesCategoriesDropdownBuilder({
    super.key,
    required this.onChanged,
  });
  final void Function(String? value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpensesCategoriesOverviewCubit(
        repository: SupabaseQueryRepository(),
      )..getData(),
      child: ExpensesCategoriesDropdown(
        onChanged: onChanged,
      ),
    );
  }
}

class ExpensesCategoriesDropdown extends StatelessWidget {
  const ExpensesCategoriesDropdown({
    super.key,
    required this.onChanged,
  });
  final void Function(String? value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesCategoriesOverviewCubit,
        ExpensesCategoriesOverviewState>(
      builder: (context, state) {
        final List<ExpenseCategory> data = switch (state) {
          ExpensesCategoriesOverviewSuccess() => state.data,
          _ => [],
        };
        return DropdownButtonFormField(
          selectedItemBuilder: (context) {
            return data.map((ExpenseCategory item) {
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
          borderRadius: BorderRadius.circular(20),
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
          ),
          items: [
            for (var category in data)
              DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
              ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}