import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:google_fonts/google_fonts.dart';

void ShowToast(
  BuildContext context, {
  required String message,
  ToastificationType type = ToastificationType.success,
  Duration duration = const Duration(seconds: 4),
  ToastificationStyle style = ToastificationStyle.fillColored,
  Alignment alignment = Alignment.topRight,
}) {
  toastification.show(
    context: context,
    title: Text(
      message,
      style: GoogleFonts.quicksand(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    type: type,
    style: style,
    autoCloseDuration: duration,
    alignment: alignment,
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.always,
    icon: _getIconForType(type),
    backgroundColor: _getBackgroundColor(type),
    foregroundColor: Colors.white,
  );
}

// Biểu tượng tương ứng với loại toast
Icon _getIconForType(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return const Icon(Icons.check_circle, color: Colors.green);
    case ToastificationType.error:
      return const Icon(Icons.error, color: Colors.red);
    case ToastificationType.warning:
      return const Icon(Icons.warning, color: Colors.orange);
    case ToastificationType.info:
      return const Icon(Icons.info, color: Colors.blue);
    default:
      return const Icon(Icons.notifications, color: Colors.grey);
  }
}

// Màu nền tùy theo loại toast
Color _getBackgroundColor(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return Colors.green.shade100;
    case ToastificationType.error:
      return Colors.red.shade100;
    case ToastificationType.warning:
      return Colors.orange.shade100;
    case ToastificationType.info:
      return Colors.blue.shade100;
    default:
      return Colors.grey.shade200;
  }
}
