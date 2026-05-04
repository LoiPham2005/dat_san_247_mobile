import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/providers/payment_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-07: Màn Thanh Toán — tích hợp VNPAY / MoMo / ZaloPay / CASH / BANK
// ──────────────────────────────────────────────────────────────────────────
const _gatewayMethods = {'VNPAY', 'MOMO', 'ZALOPAY'};

class PaymentPage extends HookConsumerWidget {
  final String bookingCode;
  final String venueName;
  final String courtName;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String paymentMethod;

  const PaymentPage({
    super.key,
    required this.bookingCode,
    required this.venueName,
    required this.courtName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPolling = useState(false);
    final hasOpenedBrowser = useState(false);
    final pendingPaymentUrl = useState<String?>(null);

    final state = ref.watch(paymentProvider);
    final notifier = ref.read(paymentProvider.notifier);
    final isLoadingUrl = state.isLoading;

    void goToSuccess() {
      context.go('/booking-success', extra: {
        'bookingCode': bookingCode,
        'checkInCode': '',
        'venueName': venueName,
        'courtName': courtName,
        'bookingDate': bookingDate,
        'startTime': startTime,
        'endTime': endTime,
        'totalAmount': totalAmount,
      });
    }

    Future<void> pollPaymentStatus() async {
      isPolling.value = true;
      await Future.delayed(const Duration(seconds: 2));
      final status = await notifier.pollPaymentStatus(bookingCode);
      if (!context.mounted) return;
      isPolling.value = false;
      if (status == 'PAID') {
        goToSuccess();
      } else {
        toast.info('Chưa nhận được xác nhận thanh toán. Vui lòng kiểm tra lại sau ít phút.');
      }
    }

    Future<void> openPaymentUrl(String url) async {
      try {
        final uri = Uri.parse(url);
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
        hasOpenedBrowser.value = true;
      } catch (_) {
        if (context.mounted) {
          toast.error('Không thể mở trang thanh toán. Vui lòng thử lại.');
        }
      }
    }

    // Init: tạo URL thanh toán cho gateway
    useEffect(() {
      if (_gatewayMethods.contains(paymentMethod)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.createPaymentUrl(paymentMethod, bookingCode);
        });
      }
      return null;
    }, const []);

    // Deep link listener
    useEffect(() {
      final appLinks = AppLinks();
      void handle(Uri uri) {
        if (uri.scheme == 'datsan247' && uri.host == 'payment-return') {
          if (!isPolling.value) {
            hasOpenedBrowser.value = true;
            pollPaymentStatus();
          }
        }
      }

      final sub = appLinks.uriLinkStream.listen(handle);
      appLinks.getInitialLink().then((uri) {
        if (uri != null) handle(uri);
      }).catchError((_) {});
      return sub.cancel;
    }, const []);

    // App lifecycle: khi resume từ background, polling lại
    useOnAppLifecycleStateChange((previous, next) {
      if (next == AppLifecycleState.resumed &&
          hasOpenedBrowser.value &&
          !isPolling.value) {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted && hasOpenedBrowser.value && !isPolling.value) {
            pollPaymentStatus();
          }
        });
      }
    });

    RiverpodListeners.async$(
      ref: ref,
      context: context,
      provider: paymentProvider,
      notifier: notifier,
      onSuccess: (url) => pendingPaymentUrl.value = url,
    );

    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final methodInfo = _methodInfo(paymentMethod);
    final isGateway = _gatewayMethods.contains(paymentMethod);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _AmountCard(amount: totalAmount, fmt: fmt, methodInfo: methodInfo),
            const SizedBox(height: 20),
            _InfoCard(
              courtName: courtName,
              venueName: venueName,
              bookingDate: bookingDate,
              startTime: startTime,
              endTime: endTime,
              bookingCode: bookingCode,
            ),
            const SizedBox(height: 16),
            if (isGateway)
              _GatewayCard(
                methodInfo: methodInfo,
                paymentUrl: pendingPaymentUrl.value,
                isPolling: isPolling.value,
                hasOpened: hasOpenedBrowser.value,
                onOpenBrowser: () {
                  if (pendingPaymentUrl.value != null) {
                    openPaymentUrl(pendingPaymentUrl.value!);
                  }
                },
                onCheckStatus: pollPaymentStatus,
              ),
            if (paymentMethod == 'CASH') const _CashCard(),
            if (paymentMethod == 'BANK_TRANSFER') const _BankTransferCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        fmt: fmt,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        paymentUrl: pendingPaymentUrl.value,
        isPolling: isPolling.value,
        hasOpenedBrowser: hasOpenedBrowser.value,
        isLoadingUrl: isLoadingUrl,
        onConfirmCash: goToSuccess,
        onOpenBrowser: () {
          if (pendingPaymentUrl.value != null) {
            openPaymentUrl(pendingPaymentUrl.value!);
          }
        },
        onCheckStatus: pollPaymentStatus,
      ),
    );
  }

  Map<String, String> _methodInfo(String method) {
    switch (method) {
      case 'MOMO':
        return {'icon': '💜', 'label': 'MoMo', 'color': 'FF00AE11'};
      case 'VNPAY':
        return {'icon': '🏦', 'label': 'VNPay', 'color': '005BAA'};
      case 'ZALOPAY':
        return {'icon': '🔵', 'label': 'ZaloPay', 'color': '0068FF'};
      case 'CASH':
        return {'icon': '💵', 'label': 'Tiền mặt', 'color': 'F59E0B'};
      default:
        return {'icon': '💳', 'label': method, 'color': '16A34A'};
    }
  }
}

// ── Sub-widgets (giữ nguyên từ file gốc) ──────────────────────────────────

class _AmountCard extends StatelessWidget {
  final double amount;
  final NumberFormat fmt;
  final Map<String, String> methodInfo;

  const _AmountCard({required this.amount, required this.fmt, required this.methodInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF16A34A).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          const Text('Số tiền thanh toán',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(fmt.format(amount),
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(methodInfo['icon']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(methodInfo['label']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String courtName, venueName, bookingDate, startTime, endTime, bookingCode;

  const _InfoCard({
    required this.courtName,
    required this.venueName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.bookingCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          _row('Mã booking', bookingCode, isCode: true),
          _row('Sân', courtName),
          _row('Địa điểm', venueName),
          _row('Ngày', DateFormat('dd/MM/yyyy').format(DateTime.parse(bookingDate))),
          _row('Giờ', '${_fmtTime(startTime)} – ${_fmtTime(endTime)}'),
        ],
      ),
    );
  }

  String _fmtTime(String raw) {
    try {
      if (raw.contains('T')) {
        final dt = DateTime.parse(raw).toLocal();
        return DateFormat('HH:mm').format(dt);
      }
      return raw.length > 5 ? raw.substring(0, 5) : raw;
    } catch (_) {
      return raw;
    }
  }

  Widget _row(String label, String value, {bool isCode = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 13)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isCode ? AppColors.primaryLightBrand : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: isCode ? FontWeight.w900 : FontWeight.w600,
                  fontFamily: isCode ? 'monospace' : null,
                ),
              ),
            ),
          ],
        ),
      );
}

class _GatewayCard extends StatelessWidget {
  final Map<String, String> methodInfo;
  final String? paymentUrl;
  final bool isPolling;
  final bool hasOpened;
  final VoidCallback onOpenBrowser;
  final VoidCallback onCheckStatus;

  const _GatewayCard({
    required this.methodInfo,
    required this.paymentUrl,
    required this.isPolling,
    required this.hasOpened,
    required this.onOpenBrowser,
    required this.onCheckStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Text(methodInfo['icon']!, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'Thanh toán qua ${methodInfo['label']}',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            hasOpened
                ? 'Sau khi thanh toán xong, nhấn "Kiểm tra kết quả" bên dưới.'
                : 'Nhấn nút bên dưới để mở trang thanh toán ${methodInfo['label']}. Bạn sẽ được chuyển ra trình duyệt.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary, height: 1.5),
          ),
          if (hasOpened && isPolling) ...[
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 10),
                Text('Đang kiểm tra trạng thái...',
                    style: TextStyle(fontSize: 13, color: AppColors.textHint)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CashCard extends StatelessWidget {
  const _CashCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vui lòng thanh toán trực tiếp tại quầy lễ tân khi đến sân. Booking sẽ được xác nhận ngay sau khi nhân viên thu tiền.',
              style: TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _BankTransferCard extends StatelessWidget {
  const _BankTransferCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_balance_rounded, color: Color(0xFF2563EB), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Chuyển khoản theo thông tin ngân hàng của chủ sân. Ghi đúng nội dung chuyển khoản là mã booking. Booking sẽ được xác nhận sau khi chủ sân nhận tiền.',
              style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final NumberFormat fmt;
  final double totalAmount;
  final String paymentMethod;
  final String? paymentUrl;
  final bool isPolling;
  final bool hasOpenedBrowser;
  final bool isLoadingUrl;
  final VoidCallback onConfirmCash;
  final VoidCallback onOpenBrowser;
  final VoidCallback onCheckStatus;

  const _BottomBar({
    required this.fmt,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentUrl,
    required this.isPolling,
    required this.hasOpenedBrowser,
    required this.isLoadingUrl,
    required this.onConfirmCash,
    required this.onOpenBrowser,
    required this.onCheckStatus,
  });

  bool get _isGateway => _gatewayMethods.contains(paymentMethod);

  String get _methodLabel {
    switch (paymentMethod) {
      case 'MOMO':
        return 'MoMo';
      case 'VNPAY':
        return 'VNPay';
      case 'ZALOPAY':
        return 'ZaloPay';
      default:
        return paymentMethod;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isGateway && !hasOpenedBrowser)
            _btn(
              label: isLoadingUrl ? 'Đang tạo liên kết...' : 'Mở trang thanh toán $_methodLabel',
              icon: Icons.open_in_browser_rounded,
              disabled: isLoadingUrl || paymentUrl == null,
              onTap: onOpenBrowser,
            ),
          if (_isGateway && hasOpenedBrowser) ...[
            _btn(
              label: isPolling ? 'Đang kiểm tra...' : 'Kiểm tra kết quả thanh toán',
              icon: Icons.refresh_rounded,
              disabled: isPolling,
              onTap: onCheckStatus,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onOpenBrowser,
              child: const Text('Mở lại trang thanh toán',
                  style: TextStyle(color: AppColors.textHint, fontSize: 13)),
            ),
          ],
          if (!_isGateway)
            _btn(
              label: paymentMethod == 'CASH'
                  ? 'Xác nhận — Thanh toán tại sân'
                  : 'Xác nhận — Tôi sẽ chuyển khoản',
              icon: paymentMethod == 'CASH'
                  ? Icons.check_circle_rounded
                  : Icons.account_balance_rounded,
              onTap: onConfirmCash,
            ),
        ],
      ),
    );
  }

  Widget _btn({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: disabled ? null : onTap,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLightBrand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}
