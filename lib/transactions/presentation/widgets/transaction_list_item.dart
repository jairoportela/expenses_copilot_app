import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/common/widgets/number_icon.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:expenses_copilot_app/utils/number_format.dart';
import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({super.key, required this.item});
  final Transaction item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: item.category.icon != null
          ? Icon(
              NumberIcons.getIconByNumber(item.category.icon!),
              color: Colors.white,
            )
          : null,
      title: Text(item.name),
      subtitle: Text(item.category.name),
      trailing: Text(
        item.value.toCOPFormatWithSign(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color:
                item.type == CategoryType.income ? Colors.greenAccent : null),
      ),
    );
  }
}
