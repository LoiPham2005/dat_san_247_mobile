import 'package:flutter/material.dart';



Widget ItemLoadFaild({
  required String message,
  Function()? onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
          onPressed: onPressed,
          child: Text(
            "Tải lại",
          ),
        ),
      ],
    ),
  );
}
