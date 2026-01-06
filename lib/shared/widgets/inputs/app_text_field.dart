import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/core/theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.borderRadius = 12,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final double borderRadius;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      textCapitalization: widget.textCapitalization,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.grey,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        filled: true,
        fillColor: widget.enabled ? AppColors.surface : AppColors.grey.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

/// Search TextField
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hint = 'Tìm kiếm...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      autofocus: autofocus,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
            )
          : null,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
    );
  }
}
