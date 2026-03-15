// 📁 lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Màu cố định (không đổi theo theme) ───
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // ─── Brand ───
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);

  // ─── Neutral / Grey ───
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);

  // ─── Semantic Text (fallback static – dùng khi không có context) ───
  /// ⚠️ Nên ưu tiên dùng context.colors.textTitle thay cho các màu này
  static const Color textPrimary = Color(0xFF1A1D23);
  static const Color textSecondary = Color(0xFF4A4F5A);
  static const Color textHint = Color(0xFF9098A9);
  static const Color textDisabled = Color(0xFFCDD1D9);

  // ─── Status (static fallback) ───
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1E88E5);
}
