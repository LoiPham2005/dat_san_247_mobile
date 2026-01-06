import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/theme/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.iconSize = 64,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: iconSize,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
