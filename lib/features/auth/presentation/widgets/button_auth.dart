import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';

class ButtonAuth extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final bool isLoading;

  const ButtonAuth({
    super.key,
    required this.name,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 150px từ Figma
      height: 48, // 48px từ Figma
      decoration: BoxDecoration(
        gradient: ColorApp.gradient,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
