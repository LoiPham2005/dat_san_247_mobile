// // lib/core/extensions/responsive_extensions.dart
// import 'package:flutter/material.dart';

// /// Breakpoints theo Material Design 3
// class Breakpoints {
//   static const double mobile = 600;    // 0-599: Mobile
//   static const double tablet = 840;    // 600-839: Tablet
//   static const double desktop = 1200;  // 840+: Desktop
// }

// extension ResponsiveExtensions on BuildContext {
//   // ═══════════════════════════════════════════════════════════════
//   // Screen Info
//   // ═══════════════════════════════════════════════════════════════
//   MediaQueryData get mediaQuery => MediaQuery.of(this);
//   Size get screenSize => mediaQuery.size;
//   double get width => screenSize.width;
//   double get height => screenSize.height;

//   // ═══════════════════════════════════════════════════════════════
//   // Device Type Detection
//   // ═══════════════════════════════════════════════════════════════
//   bool get isMobile => width < Breakpoints.mobile;
//   bool get isTablet => width >= Breakpoints.mobile && width < Breakpoints.desktop;
//   bool get isDesktop => width >= Breakpoints.desktop;

//   // ═══════════════════════════════════════════════════════════════
//   // Responsive Values (T-Shirt Sizing)
//   // ═══════════════════════════════════════════════════════════════
//   T responsive<T>({
//     required T mobile,
//     T? tablet,
//     T? desktop,
//   }) {
//     if (isDesktop && desktop != null) return desktop;
//     if (isTablet && tablet != null) return tablet;
//     return mobile;
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // Responsive Spacing
//   // ═══════════════════════════════════════════════════════════════
//   double get spacing => responsive(
//     mobile: 8.0,
//     tablet: 12.0,
//     desktop: 16.0,
//   );

//   double get padding => responsive(
//     mobile: 16.0,
//     tablet: 24.0,
//     desktop: 32.0,
//   );

//   double get margin => responsive(
//     mobile: 12.0,
//     tablet: 16.0,
//     desktop: 24.0,
//   );

//   // ═══════════════════════════════════════════════════════════════
//   // Responsive Font Sizes
//   // ═══════════════════════════════════════════════════════════════
//   double get titleSize => responsive(
//     mobile: 20.0,
//     tablet: 24.0,
//     desktop: 28.0,
//   );

//   double get bodySize => responsive(
//     mobile: 14.0,
//     tablet: 16.0,
//     desktop: 18.0,
//   );

//   // ═══════════════════════════════════════════════════════════════
//   // Responsive Grid Columns
//   // ═══════════════════════════════════════════════════════════════
//   int get gridColumns => responsive(
//     mobile: 2,
//     tablet: 3,
//     desktop: 4,
//   );

//   // ═══════════════════════════════════════════════════════════════
//   // Max Width for Content (Readable line length)
//   // ═══════════════════════════════════════════════════════════════
//   double get maxContentWidth => responsive(
//     mobile: double.infinity,
//     tablet: 800.0,
//     desktop: 1200.0,
//   );
// }
