import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Customtextfield extends ConsumerWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffix;
  final bool obscure;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;
  final bool isRequired;
  final String? Function(String?)? validator;
  final String? initialValue;

  const Customtextfield({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscure = false,
    this.enabled = true,
    this.readOnly = false,
    this.isRequired = true,
    this.validator,
    this.keyboardType,
    this.minLines,
    this.maxLines = 1,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscure,
      keyboardType: keyboardType,
      minLines: obscure ? 1 : minLines,
      maxLines: obscure ? 1 : maxLines,
      textCapitalization: textCapitalization,
      validator: (value) {
        if (isRequired) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        }
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffix: suffix,
      ),
    );
  }
}

// Widget textFormField({
//   TextEditingController? controller,
//   String? label,
//   Icon? prefixIcon,
//   Widget? suffix,
//   String? hint,
//   bool enabled = true,
//   bool readOnly = false,
//   TextInputType? keyboardType,
//   String? initialValue,
//   bool validationRequired = true,
//   bool obscure = false,
//   VoidCallback? onTap,
//   int? minLines,
//   int? maxLines,
//   TextCapitalization? textCapitalization,
// }) {
  // final effectiveMaxLines = obscure ? 1 : maxLines;
  // final effectiveMinLines = obscure ? 1 : minLines;

  // return TextFormField(
  //   onTap: onTap,
  //   controller: controller,
  //   decoration: InputDecoration(
  //     label: label != null ? Text(label) : null,
  //     prefixIcon: prefixIcon,
  //     suffix: suffix,
  //     hint: hint != null ? Text(hint) : null,
  //   ),
  //   enabled: enabled,
  //   readOnly: readOnly,
  //   keyboardType: keyboardType,
  //   initialValue: initialValue,
  //   validator: (value) {
  //     if (validationRequired) {
  //       if (value == null || value.trim().isEmpty) {
  //         return 'Required';
  //       } else {
  //         return null;
  //       }
  //     } else {
  //       return null;
  //     }
  //   },
  //   obscureText: obscure,
  //   minLines: effectiveMinLines,
  //   maxLines: effectiveMaxLines,
  //   textCapitalization: textCapitalization ?? TextCapitalization.none,
  // );
