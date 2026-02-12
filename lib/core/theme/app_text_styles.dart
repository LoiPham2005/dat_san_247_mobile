import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/theme/app_colors.dart';
import 'package:dat_san_247_mobile/gen/fonts.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = FontFamily.inter;

  // Base styles by size (using s[Size] convention)
  static TextStyle get s10 =>
      TextStyle(fontSize: 10.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s11 =>
      TextStyle(fontSize: 11.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s12 =>
      TextStyle(fontSize: 12.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s13 =>
      TextStyle(fontSize: 13.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s14 =>
      TextStyle(fontSize: 14.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s15 =>
      TextStyle(fontSize: 15.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s16 =>
      TextStyle(fontSize: 16.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s18 =>
      TextStyle(fontSize: 18.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s20 =>
      TextStyle(fontSize: 20.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s22 =>
      TextStyle(fontSize: 22.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s24 =>
      TextStyle(fontSize: 24.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s26 =>
      TextStyle(fontSize: 26.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s28 =>
      TextStyle(fontSize: 28.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s30 =>
      TextStyle(fontSize: 30.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);
  static TextStyle get s32 =>
      TextStyle(fontSize: 32.sp, fontFamily: fontFamily, height: 1.5, color: AppColors.textPrimary);

  // Specific complex styles might go here if needed
}

// Fluent API Extension for TextStyle
extension TextStyleExt on TextStyle {
  // ═══════════════════════════════════════════════════════════════
  // WEIGHTS
  // ═══════════════════════════════════════════════════════════════
  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300); // Light
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400); // Regular
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500); // Medium
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600); // SemiBold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700); // Bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800); // ExtraBold
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);

  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900); // Black
  TextStyle get blackWeight => copyWith(fontWeight: FontWeight.w900);

  // ═══════════════════════════════════════════════════════════════
  // STYLES
  // ═══════════════════════════════════════════════════════════════
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);

  // ═══════════════════════════════════════════════════════════════
  // COLORS (Shortcuts)
  // ═══════════════════════════════════════════════════════════════
  TextStyle get white => copyWith(color: Colors.white);
  TextStyle get black => copyWith(color: Colors.black);

  // App Colors
  TextStyle get primary => copyWith(color: AppColors.primary);
  TextStyle get secondary => copyWith(color: AppColors.secondary);
  TextStyle get error => copyWith(color: AppColors.error);
  TextStyle get success => copyWith(color: AppColors.success);
  TextStyle get warning => copyWith(color: AppColors.warning);
  TextStyle get info => copyWith(color: AppColors.info);

  // Neutral Colors
  TextStyle get grey => copyWith(color: AppColors.grey);
  TextStyle get greyLight => copyWith(color: AppColors.greyLight);
  TextStyle get greyDark => copyWith(color: AppColors.greyDark);

  // Semantic Text Colors
  TextStyle get textPrimary => copyWith(color: AppColors.textPrimary);
  TextStyle get textSecondary => copyWith(color: AppColors.textSecondary);
  TextStyle get textHint => copyWith(color: AppColors.textHint);
  TextStyle get textDisabled => copyWith(color: AppColors.textDisabled);

  // ═══════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════
  /// Set custom color
  TextStyle setColor(Color c) => copyWith(color: c);

  /// Set custom font size (automatically adapted with .sp)
  TextStyle size(double s) => copyWith(fontSize: s.sp);

  /// Set custom height
  TextStyle h(double v) => copyWith(height: v);

  /// Set custom letter spacing
  TextStyle letterSpace(double v) => copyWith(letterSpacing: v);

  /// Set ellipsis overflow
  TextStyle get ellipsis => copyWith(overflow: TextOverflow.ellipsis);
}
