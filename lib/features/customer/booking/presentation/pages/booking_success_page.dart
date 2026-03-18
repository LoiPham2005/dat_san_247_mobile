import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-08: Màn Đặt Sân Thành Công
// ──────────────────────────────────────────────────────────────────────────
class BookingSuccessPage extends StatefulWidget {
  final String bookingCode;
  final String checkInCode;
  final String venueName;
  final String courtName;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final double totalAmount;

  const BookingSuccessPage({
    super.key,
    required this.bookingCode,
    required this.checkInCode,
    required this.venueName,
    required this.courtName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
  });

  @override
  State<BookingSuccessPage> createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends State<BookingSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.elasticOut));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📋 Đã sao chép vào clipboard'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final date = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
        .format(DateTime.parse(widget.bookingDate));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // ── Success Icon ──────────────────────────────────────────
              const SizedBox(height: 16),
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: const Color(0xFF16A34A).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.check_rounded, color: AppColors.white, size: 50),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    const Text('Đặt sân thành công! 🎉', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('Nhớ có mặt đúng giờ nhé! Chúc bạn có trận đấu vui.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Booking Code ──────────────────────────────────────────
              _buildCodeCard(),
              const SizedBox(height: 16),

              // ── Check-in QR ───────────────────────────────────────────
              _buildQRCard(),
              const SizedBox(height: 16),

              // ── Booking Detail ────────────────────────────────────────
              _buildDetailCard(fmt, date),
              const SizedBox(height: 16),

              // ── Action Buttons ────────────────────────────────────────
              _buildActions(),
              const SizedBox(height: 16),

              // ── Go Home ───────────────────────────────────────────────
              TextButton.icon(
                onPressed: () => context.go('/main'),
                icon: const Icon(Icons.home_rounded, color: AppColors.textSecondary),
                label: const Text('Về trang chủ', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          const Text('Mã đặt sân', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _copyCode(widget.bookingCode),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryLightBrand.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryLightBrand.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.bookingCode,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand, letterSpacing: 3),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.copy_rounded, size: 18, color: AppColors.primaryLightBrand),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Nhấn để sao chép mã', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildQRCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.qr_code_scanner_rounded, color: AppColors.primaryLightBrand, size: 22),
                  SizedBox(width: 8),
                  Text('Mã Check-in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                ],
              ),
              GestureDetector(
                onTap: () => _copyCode(widget.checkInCode),
                child: Row(
                  children: [
                    Text(widget.checkInCode, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLightBrand, letterSpacing: 1.5)),
                    const SizedBox(width: 4),
                    const Icon(Icons.copy_rounded, size: 14, color: AppColors.primaryLightBrand),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // QR mock placeholder
          Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.qr_code_2_rounded, size: 130, color: AppColors.textPrimary),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightBrand,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.sports_soccer_rounded, size: 20, color: AppColors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Xuất trình mã này cho nhân viên khi đến sân', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(NumberFormat fmt, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          _detailRow(Icons.stadium_rounded, 'Sân', '${widget.courtName}'),
          const Divider(height: 20, color: AppColors.borderLight),
          _detailRow(Icons.location_on_rounded, 'Địa điểm', widget.venueName),
          const Divider(height: 20, color: AppColors.borderLight),
          _detailRow(Icons.calendar_today_rounded, 'Ngày', date),
          const Divider(height: 20, color: AppColors.borderLight),
          _detailRow(Icons.access_time_rounded, 'Giờ', '${widget.startTime} – ${widget.endTime}'),
          const Divider(height: 20, color: AppColors.borderLight),
          _detailRow(Icons.payments_rounded, 'Tổng tiền', fmt.format(widget.totalAmount), bold: true, highlight: true),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, {bool bold = false, bool highlight = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: highlight ? AppColors.primaryLightBrand : AppColors.textHint),
        const SizedBox(width: 10),
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textHint))),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              color: highlight ? AppColors.primaryLightBrand : AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Download invoice from invoices.pdf_url
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⬇️ Đang tải hóa đơn PDF...')),
              );
            },
            icon: const Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.primaryLightBrand),
            label: const Text('Tải hóa đơn', style: TextStyle(color: AppColors.primaryLightBrand, fontSize: 13, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryLightBrand),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Share deep link with booking_code
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('📤 Chia sẻ link: datsansport.vn/b/${widget.bookingCode}')),
              );
            },
            icon: const Icon(Icons.share_rounded, size: 18, color: AppColors.white),
            label: const Text('Chia sẻ', style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLightBrand,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: () {
            // TODO: Add to phone calendar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('📅 Đã thêm vào lịch!')),
            );
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.borderLight),
            padding: const EdgeInsets.all(14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Icon(Icons.calendar_month_rounded, color: AppColors.textPrimary, size: 20),
        ),
      ],
    );
  }
}
