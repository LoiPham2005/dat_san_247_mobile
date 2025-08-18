import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';

class ButtonIntro extends StatelessWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onContinue;

  const ButtonIntro({
    super.key,
    this.onSkip,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375, // Full width
      padding: EdgeInsets.symmetric(
        horizontal: 16, // 24px từ Figma
        vertical: 16, // 16px từ Figma
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Thêm này để căn đều
        children: [
          Padding(
            padding: EdgeInsets.only(left: 54),
            child: GestureDetector(
              onTap: onSkip,
              child: Text(
                "BỎ QUA",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Spacer(), // Thêm spacer để đẩy 2 nút ra xa nhau
          Container(
            width: 150,
            height: 48,
            decoration: BoxDecoration(
              gradient: ColorApp.gradient,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                "TIẾP TỤC",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
