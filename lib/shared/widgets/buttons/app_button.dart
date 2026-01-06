import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/theme/app_colors.dart';

enum AppButtonType { primary, secondary, outline, text, danger }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isExpanded = false,
    this.borderRadius,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final bool isExpanded;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(theme),
    );
  }

  Widget _buildButton(ThemeData theme) {
    final effectiveOnPressed = isLoading || isDisabled ? null : onPressed;

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(_getLoadingColor()),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _getIconSize()),
                const SizedBox(width: 8),
              ],
              Text(label, style: TextStyle(fontSize: _getFontSize())),
            ],
          );

    final buttonStyle = _getButtonStyle(theme);

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: child,
        );
    }
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    final radius = BorderRadius.circular(borderRadius ?? 12);

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: _getPadding(),
        );
      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: _getPadding(),
        );
      case AppButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: _getPadding(),
        );
      case AppButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: _getPadding(),
        );
      case AppButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: _getPadding(),
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 12;
      case AppButtonSize.medium:
        return 14;
      case AppButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  Color _getLoadingColor() {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return Colors.white;
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppColors.primary;
    }
  }
}
