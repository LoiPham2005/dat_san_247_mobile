import 'package:flutter/material.dart';

/// Page transition utilities
class PageTransition {
  PageTransition._();

  /// Slide from right (default push)
  static PageRouteBuilder slideFromRight(Widget page, {Duration? duration}) {
    return _buildRoute(
      page: page,
      duration: duration,
      begin: const Offset(1.0, 0.0),
    );
  }

  /// Slide from bottom (modal style)
  static PageRouteBuilder slideFromBottom(Widget page, {Duration? duration}) {
    return _buildRoute(
      page: page,
      duration: duration,
      begin: const Offset(0.0, 1.0),
    );
  }

  /// Slide from left (back navigation)
  static PageRouteBuilder slideFromLeft(Widget page, {Duration? duration}) {
    return _buildRoute(
      page: page,
      duration: duration,
      begin: const Offset(-1.0, 0.0),
    );
  }

  /// Fade transition
  static PageRouteBuilder fade(Widget page, {Duration? duration}) {
    return PageRouteBuilder(
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }

  /// Scale + Fade (zoom in)
  static PageRouteBuilder scale(Widget page, {Duration? duration}) {
    return PageRouteBuilder(
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static PageRouteBuilder _buildRoute({
    required Widget page,
    required Offset begin,
    Duration? duration,
  }) {
    return PageRouteBuilder(
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: begin,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
