import 'package:expenses_copilot_app/categories/data/models/models.dart';

import 'package:expenses_copilot_app/categories/data/repositories/category_repository.dart';
import 'package:expenses_copilot_app/categories/providers/categories_overview/categories_overview_cubit.dart';
import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/common/widgets/number_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gap/gap.dart';

import 'package:query_repository/query_repository.dart';

class CategoriesDropdownBuilder extends StatelessWidget {
  const CategoriesDropdownBuilder({
    super.key,
    required this.onChanged,
    required this.text,
    required this.type,
    this.initialId,
  });
  final void Function(String? value)? onChanged;
  final TextInputValue text;
  final CategoryType type;
  final String? initialId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoriesOverviewCubit(
        repository: CategoryRepositoryImplementation(
            dataSource: RepositoryProvider.of<QueryRepository>(context)),
      )..getData(type: type),
      child: CategoriesDropdown(
        onChanged: onChanged,
        text: text,
        initialId: initialId,
      ),
    );
  }
}

class CategoriesDropdown extends StatelessWidget {
  const CategoriesDropdown({
    super.key,
    required this.onChanged,
    required this.text,
    required this.initialId,
  });
  final void Function(String? value)? onChanged;
  final TextInputValue text;
  final String? initialId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesOverviewCubit, CategoriesOverviewState>(
      builder: (context, state) {
        final List<Category> data = switch (state) {
          CategoriesOverviewSuccess() => state.data,
          _ => [],
        };
        String? id;
        try {
          id = data.firstWhere((value) => value.id == initialId).id;
        } catch (_) {}

        return StringDropdownFormField(
          initialValue: id,
          text: text,
          onChanged: onChanged,
          selectedItemBuilder: (context) {
            return data.map((Category item) {
              return Container(
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(
                    minWidth: 100,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.7),
                child: FittedBox(
                  child: CategoryRowText(
                    icon: item.icon,
                    name: item.name,
                  ),
                ),
              );
            }).toList();
          },
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
          items: [
            for (var category in data)
              DropdownMenuItem(
                value: category.id,
                child: FittedBox(
                  child: CategoryRowText(
                    icon: category.icon,
                    name: category.name,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CategoryRowText extends StatelessWidget {
  const CategoryRowText({
    super.key,
    required this.name,
    required this.icon,
  });
  final String name;
  final int? icon;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (icon != null) ...[
        Icon(NumberIcons.getIconByNumber(icon!)),
        const Gap(10)
      ],
      Text(
        name,
        maxLines: 2,
      )
    ]);
  }
}
