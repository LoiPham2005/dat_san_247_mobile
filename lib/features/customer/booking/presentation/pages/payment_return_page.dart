import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/route_names.dart';

/// Trang kết quả thanh toán — hiển thị sau khi gateway redirect về app.
///
/// GoRouter nhận datsan247://payment-return → authGuard redirect → /payment-return
/// với query params: method, bookingCode, success (0|1).
class PaymentReturnPage extends StatelessWidget {
  final String method;
  final String bookingCode;
  final bool success;

  const PaymentReturnPage({
    super.key,
    required this.method,
    required this.bookingCode,
    required this.success,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Icon ──────────────────────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: success
                      ? const Color(0xFF16A34A).withValues(alpha: 0.1)
                      : const Color(0xFFDC2626).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 60,
                  color: success ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 24),

              // ── Title ─────────────────────────────────────────────
              Text(
                success ? 'Thanh toán thành công!' : 'Thanh toán thất bại',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: success ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // ── Subtitle ──────────────────────────────────────────
              Text(
                success
                    ? 'Giao dịch đã được xử lý.\nTrạng thái booking sẽ cập nhật trong vài giây.'
                    : 'Giao dịch không thành công hoặc bị hủy.\nBooking vẫn ở trạng thái chờ thanh toán.',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
                textAlign: TextAlign.center,
              ),

              // ── Booking Code ──────────────────────────────────────
              if (bookingCode.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Mã booking:', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
                      const SizedBox(width: 8),
                      Text(
                        bookingCode,
                        style: const TextStyle(
                          color: AppColors.primaryLightBrand,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // ── Method Badge ──────────────────────────────────────
              const SizedBox(height: 12),
              Text(
                'Phương thức: ${_methodLabel(method)}',
                style: const TextStyle(fontSize: 13, color: AppColors.textHint),
              ),

              const SizedBox(height: 40),

              // ── Primary CTA ───────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.go(RouteNames.main),
                  icon: Icon(
                    success ? Icons.calendar_today_rounded : Icons.home_rounded,
                    size: 20,
                  ),
                  label: Text(
                    success ? 'Xem lịch đặt sân của tôi' : 'Về trang chủ',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _methodLabel(String m) {
    switch (m.toLowerCase()) {
      case 'momo':    return 'MoMo';
      case 'vnpay':   return 'VNPay';
      case 'zalopay': return 'ZaloPay';
      default:        return m.toUpperCase();
    }
  }
}
