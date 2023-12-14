import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';

class EmailFormField extends StatefulWidget {
  const EmailFormField({
    super.key,
    required this.fieldSettings,
    required this.text,
    required this.onChanged,
    this.focusNode,
  });
  final TextFieldSettings fieldSettings;
  final Email text;
  final void Function(String value)? onChanged;
  final FocusNode? focusNode;

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textError = widget.text.displayError;
    return TextField(
      focusNode: widget.focusNode,
      controller: _controller,
      decoration: InputDecoration(
        errorText: textError?.error,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintStyle: const TextStyle(color: Color.fromRGBO(66, 66, 66, 1)),
        fillColor: AppColors.grey,
      ),
      onChanged: widget.onChanged,
      textInputAction: widget.fieldSettings.textInputAction,
      autofillHints: widget.fieldSettings.autoFillHints,
      keyboardType: widget.fieldSettings.textInputType,
      textCapitalization: widget.fieldSettings.textCapitalization,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
