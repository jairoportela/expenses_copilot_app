import 'package:expenses_copilot_app/common/widgets/form_inputs.dart';
import 'package:expenses_copilot_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.fieldSettings,
    required this.text,
    required this.onChanged,
    required this.onEditingComplete,
    this.focusNode,
  });
  final TextFieldSettings fieldSettings;
  final Password text;
  final void Function(String value)? onChanged;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  late TextEditingController _controller;

  bool showPassword = false;

  void onPressIcon() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textError = widget.text.displayError;
    return TextField(
        onEditingComplete: widget.onEditingComplete,
        focusNode: widget.focusNode,
        controller: _controller,
        obscureText: !showPassword,
        decoration: InputDecoration(
          errorText: textError?.error,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: const TextStyle(color: AppColors.grey800),
          fillColor: AppColors.grey,
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: IconButton(
                onPressed: onPressIcon,
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  size: 28,
                )),
          ),
        ),
        onChanged: widget.onChanged,
        textInputAction: widget.fieldSettings.textInputAction,
        autofillHints: widget.fieldSettings.autoFillHints,
        keyboardType: widget.fieldSettings.textInputType,
        textCapitalization: widget.fieldSettings.textCapitalization);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
