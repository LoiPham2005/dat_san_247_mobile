import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-07: Màn Thanh Toán
// ──────────────────────────────────────────────────────────────────────────
class PaymentPage extends StatefulWidget {
  final String venueName;
  final String courtName;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String paymentMethod;

  const PaymentPage({
    super.key,
    required this.venueName,
    required this.courtName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    _pulseController.repeat(reverse: true);
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    _pulseController.stop();
    setState(() => _isProcessing = false);

    // Navigate to success page
    context.pushReplacement('/booking-success', extra: {
      'bookingCode': 'DS247${DateTime.now().millisecondsSinceEpoch % 100000}',
      'checkInCode': 'CI${DateTime.now().millisecondsSinceEpoch % 10000}',
      'venueName': widget.venueName,
      'courtName': widget.courtName,
      'bookingDate': widget.bookingDate,
      'startTime': widget.startTime,
      'endTime': widget.endTime,
      'totalAmount': widget.totalAmount,
    });
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final methodInfo = _getMethodInfo(widget.paymentMethod);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Thanh toán', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Amount Card ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF16A34A).withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: [
                  const Text('Số tiền thanh toán', style: TextStyle(color: AppColors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(fmt.format(widget.totalAmount), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(color: AppColors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(methodInfo['icon']!, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Text(methodInfo['label']!, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Order Info ────────────────────────────────────────────────
            _buildInfoCard([
              _infoRow('Sân', '${widget.courtName}'),
              _infoRow('Địa điểm', widget.venueName),
              _infoRow('Ngày', DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.bookingDate))),
              _infoRow('Giờ', '${widget.startTime} – ${widget.endTime}'),
            ]),
            const SizedBox(height: 16),

            // ── QR / Payment guide ────────────────────────────────────────
            if (widget.paymentMethod != 'CASH' && widget.paymentMethod != 'WALLET')
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    Text(
                      'Quét mã QR ${methodInfo['label']} để thanh toán',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    // Mock QR placeholder
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.mutedLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_2_rounded, size: 80, color: AppColors.textPrimary),
                          SizedBox(height: 8),
                          Text('QR được tạo sau khi\nxác nhận thanh toán', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Mã QR có hiệu lực trong 15 phút', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  ],
                ),
              ),

            if (widget.paymentMethod == 'WALLET')
              _buildWalletCard(fmt),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayButton(fmt),
    );
  }

  Widget _buildWalletCard(NumberFormat fmt) {
    const walletBalance = 500000.0; // mock
    final isEnough = walletBalance >= widget.totalAmount;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLightBrand.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryLightBrand, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Số dư ví', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                Text(fmt.format(walletBalance), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isEnough ? AppColors.primaryLightBrand : AppColors.error)),
              ],
            ),
          ),
          if (!isEnough)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Text('Không đủ số dư', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildPayButton(NumberFormat fmt) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: _isProcessing ? _pulseAnimation.value : 1.0,
          child: child,
        ),
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLightBrand,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            minimumSize: const Size(double.infinity, 56),
            elevation: 0,
          ),
          child: _isProcessing
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.white)),
                    SizedBox(width: 12),
                    Text('Đang xử lý...', style: TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold)),
                  ],
                )
              : Text('Xác nhận thanh toán ${fmt.format(widget.totalAmount)}', style: const TextStyle(fontSize: 15, color: AppColors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> rows) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      children: rows.map((r) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: r)).toList(),
    ),
  );

  Widget _infoRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 13)),
      Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
    ],
  );

  Map<String, String> _getMethodInfo(String method) {
    switch (method) {
      case 'MOMO': return {'icon': '💜', 'label': 'MoMo'};
      case 'VNPAY': return {'icon': '🔵', 'label': 'VNPay'};
      case 'ZALOPAY': return {'icon': '🟢', 'label': 'ZaloPay'};
      case 'WALLET': return {'icon': '👛', 'label': 'Ví tài khoản'};
      case 'CASH': return {'icon': '💵', 'label': 'Tiền mặt'};
      default: return {'icon': '💳', 'label': method};
    }
  }
}
