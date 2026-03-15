// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/toast_service.dart (SMART DIALOG)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';

import '../../base/di/injection.dart';

ToastService get toast => getIt<ToastService>();

@LazySingleton()
class ToastService {
  // ═══════════════════════════════════════════════════════════════
  // Typography & Themes
  // ═══════════════════════════════════════════════════════════════

  TextStyle _textStyle({bool isTitle = false}) => GoogleFonts.quicksand(
    fontWeight: isTitle ? FontWeight.bold : FontWeight.w600,
    fontSize: isTitle ? 15 : 14,
    color: Colors.white,
  );

  // ═══════════════════════════════════════════════════════════════
  // TOAST METHODS
  // ═══════════════════════════════════════════════════════════════

  void success(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    _showCustomToast(
      message: message,
      title: title,
      duration: duration,
      icon: Icons.check_circle_rounded,
      backgroundColor: Colors.green.shade600,
    );
  }

  void error(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    _showCustomToast(
      message: message,
      title: title,
      duration: duration,
      icon: Icons.error_outline_rounded,
      backgroundColor: Colors.red.shade600,
    );
  }

  void warning(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    _showCustomToast(
      message: message,
      title: title,
      duration: duration,
      icon: Icons.warning_amber_rounded,
      backgroundColor: Colors.orange.shade700,
    );
  }

  void info(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    _showCustomToast(
      message: message,
      title: title,
      duration: duration,
      icon: Icons.info_outline_rounded,
      backgroundColor: Colors.blue.shade600,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PRIVATE HELPER FOR CUSTOM TOASTS
  // ═══════════════════════════════════════════════════════════════

  void _showCustomToast({
    required String message,
    String? title,
    required IconData icon,
    required Color backgroundColor,
    Duration? duration,
    Alignment? alignment,
  }) {
    SmartDialog.showToast(
      '',
      displayTime: duration ?? const Duration(seconds: 3),
      alignment: alignment ?? Alignment.topRight,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: _textStyle(
                        isTitle: true,
                      ).copyWith(color: Colors.white, letterSpacing: 0.5),
                    ),
                  Text(
                    message,
                    style: _textStyle().copyWith(
                      color: Colors.white.withOpacity(0.95),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 8),
            // // Nút đóng (X)
            // GestureDetector(
            //   onTap: () => SmartDialog.dismiss(status: SmartStatus.toast),
            //   child: Container(
            //     padding: const EdgeInsets.all(4),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.2),
            //       shape: BoxShape.circle,
            //     ),
            //     child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LOADING METHODS
  // ═══════════════════════════════════════════════════════════════

  void loading([String message = 'Đang tải...']) {
    SmartDialog.showLoading(
      msg: message,
      maskColor: Colors.black.withOpacity(0.3),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(strokeWidth: 3),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hiển thị loading quảng cáo (Toàn màn hình trắng)
  void showAdLoading() {
    SmartDialog.showLoading(
      maskColor: Colors.white,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

  void stopLoading() {
    SmartDialog.dismiss(status: SmartStatus.loading);
  }

  // ═══════════════════════════════════════════════════════════════
  // DISMISS & UTILS
  // ═══════════════════════════════════════════════════════════════

  void dismiss() {
    SmartDialog.dismiss();
  }

  void fromException(dynamic exception) {
    String message = 'Đã xảy ra lỗi';
    if (exception is Exception) {
      message = exception.toString().replaceAll('Exception: ', '');
    } else {
      message = exception.toString();
    }
    error(message, title: 'Lỗi');
  }
}
