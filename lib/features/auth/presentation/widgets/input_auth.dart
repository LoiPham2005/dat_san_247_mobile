import 'package:dat_san_247_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputAuth extends StatefulWidget {
  final Icon icon;
  final bool suffixIcon;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  const InputAuth(
      {super.key,
      required this.controller,
      this.hintText,
      required this.keyboardType,
      required this.obscureText,
      required this.icon,
      required this.suffixIcon});

  @override
  State<InputAuth> createState() => _InputAuthState();
}

class _InputAuthState extends State<InputAuth> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixIcon
              ? IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      // widget.obscureText = !widget.obscureText;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          filled: true,
          fillColor: AppColors.grayF6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          )),
    );
  }
}
