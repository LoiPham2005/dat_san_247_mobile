import 'package:flutter/material.dart';
import '../buttons/app_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
  });

  final String title;
  final Widget? content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: 16),
          ],
          Text(title, textAlign: TextAlign.center),
        ],
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: actions,
    );
  }

  /// Show simple info dialog
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        icon: Icons.info_outline,
        iconColor: Colors.blue,
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          AppButton(
            onPressed: () => Navigator.pop(context),
            label: buttonText,
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  /// Show success dialog
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        content: message != null ? Text(message, textAlign: TextAlign.center) : null,
        actions: [
          AppButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed?.call();
            },
            label: buttonText,
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          AppButton(
            onPressed: () => Navigator.pop(context),
            label: buttonText,
            type: AppButtonType.danger,
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
