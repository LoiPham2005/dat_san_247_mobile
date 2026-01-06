import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom IconButton với nhiều style
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size,
    this.iconSize,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.isLoading = false,
    this.isDisabled = false,
    this.elevation,
    this.splashRadius,
    this.style = AppIconButtonStyle.standard,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final double? iconSize;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsets? padding;
  final String? tooltip;
  final bool isLoading;
  final bool isDisabled;
  final double? elevation;
  final double? splashRadius;
  final AppIconButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSize = size ?? 44.r;
    final effectiveIconSize = iconSize ?? 24.r;

    final effectiveColor = _getColor(theme);
    final effectiveBgColor = _getBackgroundColor(theme);

    Widget child = isLoading
        ? SizedBox(
            width: effectiveIconSize * 0.8,
            height: effectiveIconSize * 0.8,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: effectiveColor,
            ),
          )
        : Icon(
            icon,
            size: effectiveIconSize,
            color: isDisabled ? theme.disabledColor : effectiveColor,
          );

    Widget button = _buildButton(
      context: context,
      child: child,
      size: effectiveSize,
      backgroundColor: effectiveBgColor,
      theme: theme,
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  Widget _buildButton({
    required BuildContext context,
    required Widget child,
    required double size,
    required Color? backgroundColor,
    required ThemeData theme,
  }) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    switch (style) {
      case AppIconButtonStyle.standard:
        return IconButton(
          onPressed: isEnabled ? onPressed : null,
          icon: child,
          iconSize: iconSize ?? 24.r,
          splashRadius: splashRadius ?? 24.r,
          padding: padding ?? EdgeInsets.zero,
          color: color,
        );

      case AppIconButtonStyle.filled:
        return _FilledIconButton(
          onPressed: isEnabled ? onPressed : null,
          size: size,
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          borderRadius: borderRadius ?? size / 2,
          elevation: elevation ?? 0,
          padding: padding,
          child: child,
        );

      case AppIconButtonStyle.outlined:
        return _OutlinedIconButton(
          onPressed: isEnabled ? onPressed : null,
          size: size,
          borderColor: borderColor ?? theme.colorScheme.outline,
          borderWidth: borderWidth ?? 1,
          borderRadius: borderRadius ?? size / 2,
          padding: padding,
          child: child,
        );

      case AppIconButtonStyle.tonal:
        return _FilledIconButton(
          onPressed: isEnabled ? onPressed : null,
          size: size,
          backgroundColor:
              backgroundColor ?? theme.colorScheme.primaryContainer,
          borderRadius: borderRadius ?? size / 2,
          elevation: 0,
          padding: padding,
          child: child,
        );
    }
  }

  Color _getColor(ThemeData theme) {
    if (color != null) return color!;

    switch (style) {
      case AppIconButtonStyle.standard:
        return theme.colorScheme.onSurface;
      case AppIconButtonStyle.filled:
        return theme.colorScheme.onPrimary;
      case AppIconButtonStyle.outlined:
        return theme.colorScheme.primary;
      case AppIconButtonStyle.tonal:
        return theme.colorScheme.onPrimaryContainer;
    }
  }

  Color? _getBackgroundColor(ThemeData theme) {
    if (backgroundColor != null) return backgroundColor;

    switch (style) {
      case AppIconButtonStyle.standard:
        return null;
      case AppIconButtonStyle.filled:
        return theme.colorScheme.primary;
      case AppIconButtonStyle.outlined:
        return Colors.transparent;
      case AppIconButtonStyle.tonal:
        return theme.colorScheme.primaryContainer;
    }
  }
}

class _FilledIconButton extends StatelessWidget {
  const _FilledIconButton({
    required this.onPressed,
    required this.size,
    required this.backgroundColor,
    required this.borderRadius,
    required this.elevation,
    required this.child,
    this.padding,
  });

  final VoidCallback? onPressed;
  final double size;
  final Color backgroundColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: size,
          height: size,
          padding: padding,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class _OutlinedIconButton extends StatelessWidget {
  const _OutlinedIconButton({
    required this.onPressed,
    required this.size,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.child,
    this.padding,
  });

  final VoidCallback? onPressed;
  final double size;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: size,
          height: size,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: child,
        ),
      ),
    );
  }
}

enum AppIconButtonStyle {
  standard,
  filled,
  outlined,
  tonal,
}

// ════════════════════════════════════════════════════════════════
// EXTENSIONS
// ════════════════════════════════════════════════════════════════

extension AppIconButtonX on AppIconButton {
  /// Icon button với badge
  Widget withBadge({
    required int count,
    Color? badgeColor,
    Color? textColor,
  }) {
    if (count <= 0) return this;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        this,
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: badgeColor ?? Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
