
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    this.radius,
    this.keyboardType,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.initialValue,
    this.suffix,
    this.prefixIcon,
    this.fillColor,
    this.hintStyle,
    this.errorText,
    this.border,
    this.contentPadding,
    this.textAlign,
    this.style,
    this.onTap,
    this.enabled = true, this.inputFormatters, this.prefixIconConstraints,
  });

  final String hintText;
  final String? initialValue;
  final double? radius;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool isPassword;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final TextAlign? textAlign;
  final BoxConstraints? prefixIconConstraints;
  final void Function()? onTap;
  final String? errorText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool obscureText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: obscureText,
          initialValue: widget.initialValue,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          textAlign: widget.textAlign ?? TextAlign.start,
          onChanged: widget.onChanged,
          style: widget.style ?? const TextStyle(
            color: ColorApp.gray82,
            height: 21.03 / 14,
          ),
          onTap: widget.onTap,
          maxLength: widget.isPassword ? 32 : null,
          decoration: InputDecoration(
            counter: const Offstage(),
            filled: true,
            isDense: true,
            enabled: widget.enabled,
            contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            fillColor: widget.fillColor ?? ColorApp.grayF6,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ?? const TextStyle(
              color: ColorApp.gray82,
              height: 21.03 / 14,
            ),
            suffixIcon: widget.suffixIcon ??
                (widget.isPassword
                    ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: ColorApp.gray82,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
                    : null),
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: widget.prefixIconConstraints,
            suffix: widget.suffix,
            border: widget.border ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 100),
              borderSide: BorderSide.none,
            ),
            enabledBorder: widget.border ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 100),
              borderSide: BorderSide.none,
            ),
            disabledBorder: widget.border ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 100),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 100),
              borderSide: BorderSide(
                color: ColorApp.primaryColor.withValues(alpha: 0.16),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 100),
              borderSide: BorderSide(
                color: ColorApp.redF0,
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: TextStyle(
              color: ColorApp.redF0,
            ),
          ).paddingOnly(left:15, top: 5),
      ],
    );
  }
}


class AppTextField1 extends StatefulWidget {
  const AppTextField1({
    super.key,
    required this.hintText,
    this.radius,
    this.keyboardType,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.initialValue,
    this.suffix,
    this.prefixIcon,
    this.fillColor,
    this.hintStyle,
    this.border,
    this.contentPadding,
    this.textAlign,
    this.style,
    this.onTap,
    this.enabled = true, this.inputFormatters, this.prefixIconConstraints,
    this.focusNode
  });

  final String hintText;
  final String? initialValue;
  final double? radius;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool isPassword;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final FocusNode? focusNode;
  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final TextAlign? textAlign;
  final BoxConstraints? prefixIconConstraints;
  final void Function()? onTap;

  @override
  State<AppTextField1> createState() => _AppTextField1State();
}

class _AppTextField1State extends State<AppTextField1> {
  bool obscureText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      scrollPadding: EdgeInsets.only(bottom: 150.0),
      keyboardType: widget.keyboardType,
      obscureText: obscureText,
      initialValue: widget.initialValue,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      validator: widget.validator,
      textAlign: widget.textAlign ?? TextAlign.start,
      onChanged: widget.onChanged,
      style: widget.style ?? const TextStyle(
        color: ColorApp.black,
        height: 21.03 / 14,
      ),
      onTap: widget.onTap,
      maxLength: widget.isPassword ? 32 : null,
      decoration: InputDecoration(
        counter: const Offstage(),
        filled: true,
        isDense: true,
        enabled: widget.enabled,
        contentPadding:
        widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        fillColor: widget.fillColor ?? ColorApp.grayF6,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ?? const TextStyle(
          color: ColorApp.gray82,
          height: 21.03 / 14,
        ),
        suffixIcon: widget.suffixIcon ??
            (widget.isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: ColorApp.gray82,
              ),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            )
                : null),
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        suffix: widget.suffix,
        border: widget.border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: widget.border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 100),
          borderSide: BorderSide.none,
        ),
        disabledBorder: widget.border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 100),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 100),
          borderSide: BorderSide(
            color: ColorApp.primaryColor.withOpacity(0.16),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 100),
          borderSide: BorderSide(
            color: ColorApp.redF0.withOpacity(0.16),
          ),
        ),
      ),
    );
  }
}