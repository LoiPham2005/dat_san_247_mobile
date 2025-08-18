import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/widget/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/send_email.dart';

class RememberPass extends StatefulWidget {
  const RememberPass({super.key});

  @override
  State<RememberPass> createState() => _RememberPassState();
}

class _RememberPassState extends State<RememberPass> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
            checkColor: Colors.white,
            activeColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        const Text(
          "Ghi nhớ mật khẩu",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
              context, PageTransition.slideTransition(SendEmail())),
          child: Text(
            "Quên mật khẩu?",
            style: TextStyle(
              fontSize: 14,
              color: ColorApp.orangeE6,
            ),
          ),
        ),
      ],
    );
  }
}
