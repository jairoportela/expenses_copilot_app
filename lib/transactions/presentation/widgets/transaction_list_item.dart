import 'package:expenses_copilot_app/categories/data/models/category_type.dart';
import 'package:expenses_copilot_app/common/widgets/number_icon.dart';
import 'package:expenses_copilot_app/transactions/data/models/transaction.dart';
import 'package:expenses_copilot_app/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:expenses_copilot_app/utils/date_format.dart';
import 'package:expenses_copilot_app/utils/number_format.dart';
import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem(
      {super.key, required this.item, this.showDate = false});
  final Transaction item;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onTap: () {
        Navigator.of(context).pushNamed(
          TransactionDetailScreen.routeName,
          arguments: TransactionDetailArguments(
            title: item.name,
            id: item.id,
            type: item.type,
            iconData: item.category.icon,
          ),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: item.category.icon != null
          ? Hero(
              tag: 'icon-${item.id}',
              child: Icon(
                NumberIcons.getIconByNumber(item.category.icon!),
                color: Colors.white,
              ),
            )
          : null,
      title: Text(item.name),
      subtitle: showDate ? Text(item.date.yMMMd()) : Text(item.category.name),
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
