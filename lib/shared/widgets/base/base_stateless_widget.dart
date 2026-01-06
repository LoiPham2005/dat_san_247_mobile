import 'package:flutter/material.dart';

/// Base StatelessWidget với các tiện ích
abstract class BaseStatelessWidget extends StatelessWidget {
  const BaseStatelessWidget({super.key});

  /// Lấy Theme
  ThemeData theme(BuildContext context) => Theme.of(context);

  /// Lấy ColorScheme
  ColorScheme colors(BuildContext context) => Theme.of(context).colorScheme;

  /// Lấy TextTheme
  TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

  /// Lấy MediaQuery
  MediaQueryData mediaQuery(BuildContext context) => MediaQuery.of(context);

  /// Screen size
  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  /// Is dark mode
  bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
