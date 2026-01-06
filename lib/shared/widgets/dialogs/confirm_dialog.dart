import 'package:flutter/material.dart';
import '../buttons/app_button.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Xác nhận',
    this.cancelText = 'Hủy',
    this.isDanger = false,
    this.icon,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDanger;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 48,
              color: isDanger ? Colors.red : Colors.orange,
            ),
            const SizedBox(height: 16),
          ],
          Text(title, textAlign: TextAlign.center),
        ],
      ),
      content: Text(message, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Expanded(
          child: AppButton(
            onPressed: () => Navigator.pop(context, false),
            label: cancelText,
            type: AppButtonType.outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            onPressed: () => Navigator.pop(context, true),
            label: confirmText,
            type: isDanger ? AppButtonType.danger : AppButtonType.primary,
          ),
        ),
      ],
    );
  }

  /// Show confirm dialog và return kết quả
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    bool isDanger = false,
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDanger: isDanger,
        icon: icon ?? (isDanger ? Icons.warning_outlined : Icons.help_outline),
      ),
    );
    return result ?? false;
  }

  /// Show delete confirm
  static Future<bool> showDelete(
    BuildContext context, {
    String title = 'Xác nhận xóa',
    String message = 'Bạn có chắc muốn xóa? Hành động này không thể hoàn tác.',
  }) {
    return show(
      context,
      title: title,
      message: message,
      confirmText: 'Xóa',
      isDanger: true,
      icon: Icons.delete_outline,
    );
  }
}
