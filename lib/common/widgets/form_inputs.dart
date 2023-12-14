import 'package:expenses_copilot_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';

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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: const TextStyle(color: AppColors.grey800),
          fillColor: AppColors.grey,
        ),
        onChanged: onChanged,
        textInputAction: fieldSettings.textInputAction,
        autofillHints: fieldSettings.autoFillHints,
        keyboardType: fieldSettings.textInputType,
        textCapitalization: fieldSettings.textCapitalization);
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
