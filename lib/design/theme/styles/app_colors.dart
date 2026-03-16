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

  // ─── Web Sync (Shadcn/Tailwind) ───
  // Light Theme
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF020817);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color popoverLight = Color(0xFFFFFFFF);
  static const Color primaryLightBrand = Color(0xFF16A34A);
  static const Color primaryForegroundLight = Color(0xFFFFF1F2);
  static const Color secondaryLightBrand = Color(0xFFF1F5F9);
  static const Color secondaryForegroundLight = Color(0xFF0F172A);
  static const Color mutedLight = Color(0xFFF1F5F9);
  static const Color mutedForegroundLight = Color(0xFF64748B);
  static const Color accentLight = Color(0xFFF1F5F9);
  static const Color accentForegroundLight = Color(0xFF0F172A);
  static const Color destructiveLight = Color(0xFFEF4444);
  static const Color destructiveForegroundLight = Color(0xFFF8FAFC);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color inputLight = Color(0xFFE2E8F0);
  static const Color ringLight = Color(0xFF16A34A);
  static const Color white70 = Colors.white70;

  // Dark Theme
  static const Color backgroundDark = Color(0xFF020817);
  static const Color foregroundDark = Color(0xFFF8FAFC);
  static const Color cardDark = Color(0xFF020817);
  static const Color popoverDark = Color(0xFF020817);
  static const Color primaryDarkBrand = Color(0xFF22C55E);
  static const Color primaryForegroundDark = Color(0xFF052E16);
  static const Color secondaryDarkBrand = Color(0xFF1E293B);
  static const Color secondaryForegroundDark = Color(0xFFF8FAFC);
  static const Color mutedDark = Color(0xFF1E293B);
  static const Color mutedForegroundDark = Color(0xFF94A3B8);
  static const Color accentDark = Color(0xFF1E293B);
  static const Color accentForegroundDark = Color(0xFFF8FAFC);
  static const Color destructiveDark = Color(0xFF7F1D1D);
  static const Color destructiveForegroundDark = Color(0xFFF8FAFC);
  static const Color borderDark = Color(0xFF1E293B);
  static const Color inputDark = Color(0xFF1E293B);
  static const Color ringDark = Color(0xFF16A34A);
}
