import 'package:flutter/material.dart';

Widget textFormField({
  TextEditingController? controller,
  String? label,
  Icon? prefixIcon,
  Widget? suffix,
  String? hint,
  bool enabled = true,
  bool readOnly = false,
  TextInputType? keyboardType,
  String? initialValue,
  bool validationRequired = true,
  bool obscure = false,
  VoidCallback? onTap,
  int? minLines,
  int? maxLines,
}) {
  final effectiveMaxLines = obscure ? 1 : maxLines;
  final effectiveMinLines = obscure ? 1 : minLines;

  return TextFormField(
    onTap: onTap,
    controller: controller,
    decoration: InputDecoration(
      label: label != null ? Text(label) : null,
      prefixIcon: prefixIcon,
      suffix: suffix,
      hint: hint != null ? Text(hint) : null,
    ),
    enabled: enabled,
    readOnly: readOnly,
    keyboardType: keyboardType,
    initialValue: initialValue,
    validator: (value) {
      if (validationRequired) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        } else {
          return null;
        }
      } else {
        return null;
      }
    },
    obscureText: obscure,
    minLines: effectiveMinLines,
    maxLines: effectiveMaxLines,
  );
}
