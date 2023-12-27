import 'package:expenses_copilot_app/transactions/providers/transactions_overview/transactions_overview_bloc.dart';
import 'package:flutter/material.dart';

class TransactionFilterRow extends StatefulWidget {
  const TransactionFilterRow({
    super.key,
    required this.onSelected,
  });

  final Function(TransactionTypeFilter value) onSelected;

  @override
  State<TransactionFilterRow> createState() => _TransactionFilterRowState();
}

class _TransactionFilterRowState extends State<TransactionFilterRow> {
  int _value = 0;

  final List<TransactionTypeFilter> _filters = [
    TransactionTypeFilter.all,
    TransactionTypeFilter.expenses,
    TransactionTypeFilter.incomes
  ];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: List<Widget>.generate(
        3,
        (int index) {
          return ChoiceChip(
            showCheckmark: false,
            label: Text(_filters.elementAt(index).name),
            selected: _value == index,
            onSelected: (bool selected) {
              if (selected) {
                setState(() {
                  _value = index;
                });
                widget.onSelected(_filters.elementAt(_value));
              }
            },
          );
        },
      ).toList(),
    );
  }
}
