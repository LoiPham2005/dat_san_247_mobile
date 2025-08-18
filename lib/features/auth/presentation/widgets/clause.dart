import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';

class Clause extends StatefulWidget {
  const Clause({super.key});

  @override
  State<Clause> createState() => _ClauseState();
}

class _ClauseState extends State<Clause> {
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
          "Đồng ý điều khoản & chính sách của EZDEAL",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
