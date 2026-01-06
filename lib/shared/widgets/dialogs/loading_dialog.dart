import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Loading Dialog - Hiển thị trong quá trình xử lý
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.message,
    this.dismissible = false,
  });

  final String? message;
  final bool dismissible;

  /// Show loading dialog
  static Future<void> show(
    BuildContext context, {
    String? message,
    bool dismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => LoadingDialog(
        message: message,
        dismissible: dismissible,
      ),
    );
  }

  /// Hide loading dialog
  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: dismissible,
      child: Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48.r,
                height: 48.r,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (message != null) ...[
                SizedBox(height: 16.h),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Progress Dialog - Hiển thị tiến trình
class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    super.key,
    required this.progress,
    this.message,
    this.dismissible = false,
    this.showPercentage = true,
  });

  final double progress;
  final String? message;
  final bool dismissible;
  final bool showPercentage;

  /// Show progress dialog
  static Future<void> show(
    BuildContext context, {
    required double progress,
    String? message,
    bool dismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => ProgressDialog(
        progress: progress,
        message: message,
        dismissible: dismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (progress * 100).toInt();

    return PopScope(
      canPop: dismissible,
      child: Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80.r,
                    height: 80.r,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (showPercentage)
                    Text(
                      '$percentage%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),

              if (message != null) ...[
                SizedBox(height: 16.h),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Success Dialog - Hiển thị thành công
class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.message,
    this.title,
    this.buttonText,
    this.onPressed,
  });

  final String message;
  final String? title;
  final String? buttonText;
  final VoidCallback? onPressed;

  static Future<void> show(
    BuildContext context, {
    required String message,
    String? title,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (_) => SuccessDialog(
        message: message,
        title: title,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48.r,
              ),
            ),

            SizedBox(height: 16.h),

            // Title
            if (title != null)
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

            SizedBox(height: 8.h),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed ?? () => Navigator.of(context).pop(),
                child: Text(buttonText ?? 'OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error Dialog - Hiển thị lỗi
class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.message,
    this.title,
    this.buttonText,
    this.onPressed,
    this.onRetry,
  });

  final String message;
  final String? title;
  final String? buttonText;
  final VoidCallback? onPressed;
  final VoidCallback? onRetry;

  static Future<void> show(
    BuildContext context, {
    required String message,
    String? title,
    String? buttonText,
    VoidCallback? onPressed,
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      builder: (_) => ErrorDialog(
        message: message,
        title: title,
        buttonText: buttonText,
        onPressed: onPressed,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48.r,
              ),
            ),

            SizedBox(height: 16.h),

            // Title
            Text(
              title ?? 'Lỗi',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                if (onRetry != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry!();
                      },
                      child: const Text('Thử lại'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPressed ?? () => Navigator.of(context).pop(),
                    child: Text(buttonText ?? 'Đóng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
