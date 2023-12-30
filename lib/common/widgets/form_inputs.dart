import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.title,
    required this.child,
    this.isRequired = false,
  });
  final String title;
  final Widget child;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title ${isRequired ? "*" : ""}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.fieldSettings,
    required this.text,
    required this.onChanged,
    this.controller,
    this.focusNode,
  });
  final TextFieldSettings fieldSettings;
  final TextInputValue text;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final textError = text.displayError;
    return TextField(
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
          errorText: textError?.message,
        ),
        onChanged: onChanged,
        textInputAction: fieldSettings.textInputAction,
        autofillHints: fieldSettings.autoFillHints,
        keyboardType: fieldSettings.textInputType,
        textCapitalization: fieldSettings.textCapitalization);
  }
}

class CustomCurrencyFormField extends StatelessWidget {
  const CustomCurrencyFormField({
    super.key,
    required this.fieldSettings,
    required this.text,
    required this.onChanged,
    this.controller,
    this.focusNode,
  });
  final TextFieldSettings fieldSettings;
  final NumberInputValue text;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final textError = text.displayError;
    return TextField(
        focusNode: focusNode,
        controller: controller,
        inputFormatters: [
          ThousandsFormatter(
            formatter: NumberFormat.decimalPattern('es'),
            allowFraction: true,
          ),
        ],
        decoration: InputDecoration(
          errorText: textError?.message,
        ),
        onChanged: onChanged,
        textInputAction: fieldSettings.textInputAction,
        autofillHints: fieldSettings.autoFillHints,
        keyboardType: fieldSettings.textInputType,
        textCapitalization: fieldSettings.textCapitalization);
  }
}

class StringDropdownFormField extends StatelessWidget {
  const StringDropdownFormField({
    super.key,
    required this.text,
    required this.onChanged,
    required this.items,
    this.selectedItemBuilder,
    this.focusNode,
    this.icon,
    this.initialValue,
  });

  final TextInputValue text;

  final void Function(String? value)? onChanged;
  final FocusNode? focusNode;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final List<DropdownMenuItem<String>>? items;
  final Widget? icon;
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    final textError = text.displayError;
    return DropdownButtonFormField<String>(
      value: initialValue,
      focusNode: focusNode,
      decoration: InputDecoration(
        errorText: textError?.message,
      ),
      selectedItemBuilder: selectedItemBuilder,
      borderRadius: BorderRadius.circular(20),
      icon: icon,
      items: items,
      onChanged: onChanged,
    );
  }
}

class TextFieldSettings {
  const TextFieldSettings({
    this.textInputAction = TextInputAction.next,
    this.autoFillHints,
    this.textInputType,
    this.textCapitalization = TextCapitalization.none,
  });
  final TextInputAction? textInputAction;
  final List<String>? autoFillHints;
  final TextInputType? textInputType;
  final TextCapitalization textCapitalization;
}
