import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/write_review_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/cancel_booking_page.dart';
import '../widgets/booking_code_status_card.dart';
import '../widgets/venue_info_detail_card.dart';
import '../widgets/addons_detail_card.dart';
import '../widgets/price_detail_card.dart';
import '../widgets/booking_payment_info_card.dart';
import '../widgets/booking_history_card.dart';
import '../widgets/booking_note_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-10: Chi Tiết Booking
// ──────────────────────────────────────────────────────────────────────────
class BookingDetailPage extends StatelessWidget {
  final BookingListItemModel booking;
  const BookingDetailPage({super.key, required this.booking});

  // Mock full detail — sau thay bằng API
  BookingDetailModel _getMockDetail() {
    return BookingDetailModel(
      id: booking.id,
      bookingCode: booking.bookingCode,
      checkInCode: booking.checkInCode,
      venueName: booking.venueName,
      courtName: booking.courtName,
      venueAddress: booking.venueAddress,
      venueThumbnailUrl: booking.venueThumbnailUrl,
      bookingDate: booking.bookingDate,
      startTime: booking.startTime,
      endTime: booking.endTime,
      totalHours: 1,
      pricePerHour: 150000,
      subTotal: 150000,
      discountAmount: 0,
      vatRate: 0,
      vatAmount: 0,
      totalAmount: booking.totalAmount,
      refundAmount: 0,
      cancellationFee: 0,
      promotionCode: null,
      note: 'Mang theo giày cỏ',
      status: booking.status,
      paymentStatus: booking.paymentStatus,
      paymentMethod: 'MOMO',
      paidAt: booking.paymentStatus == PaymentStatus.PAID ? DateTime.now().subtract(const Duration(hours: 1)) : null,
      cancellationDeadline: booking.cancellationDeadline,
      createdAt: booking.createdAt,
      addons: [
        BookingAddonDetailModel(id: 'a1', bookingId: booking.id, serviceId: 's1', serviceName: 'Thuê áo đá bóng', quantity: 2, pricePerUnit: 30000, totalPrice: 60000),
      ],
      statusHistory: [
        BookingStatusHistoryModel(id: 'sh1', bookingId: booking.id, status: BookingStatus.PENDING, actorRole: ActorRole.CUSTOMER, note: 'Đặt sân mới', createdAt: booking.createdAt),
        if (booking.status != BookingStatus.PENDING)
          BookingStatusHistoryModel(id: 'sh2', bookingId: booking.id, status: booking.status, actorRole: ActorRole.CUSTOMER, createdAt: booking.createdAt.add(const Duration(minutes: 30))),
      ],
      payments: booking.paymentStatus == PaymentStatus.PAID
          ? [PaymentDetailModel(id: 'p1', bookingId: booking.id, amount: booking.totalAmount, paymentMethod: PaymentMethod.MOMO, status: PaymentStatus.PAID, paidAt: DateTime.now().subtract(const Duration(hours: 1)))]
          : [],
      hasReview: false,
      refundRules: [
        RefundRuleModel(id: 'r1', cancelBeforeHours: 24, refundPercentage: 100, description: 'Hủy trước 24h: hoàn 100%'),
        RefundRuleModel(id: 'r2', cancelBeforeHours: 4, refundPercentage: 50, description: 'Hủy trước 4h: hoàn 50%'),
        RefundRuleModel(id: 'r3', cancelBeforeHours: 0, refundPercentage: 0, description: 'Hủy dưới 4h: không hoàn'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final detail = _getMockDetail();
    final (statusColor, statusBg, statusIcon) = _statusStyle(detail.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chi tiết đặt sân', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        actions: [
          if (detail.status == BookingStatus.CONFIRMED && detail.checkInCode != null)
            IconButton(
              icon: const Icon(Icons.qr_code_2_rounded, color: AppColors.primaryLightBrand),
              onPressed: () => _showQRModal(context, detail.checkInCode!),
              tooltip: 'Mã QR Check-in',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BookingCodeStatusCard(
              detail: detail,
              statusColor: statusColor,
              statusBg: statusBg,
              statusIcon: statusIcon,
            ),
            const SizedBox(height: 14),
            VenueInfoDetailCard(detail: detail),
            const SizedBox(height: 14),
            if (detail.addons.isNotEmpty) ...[
              AddonsDetailCard(addons: detail.addons),
              const SizedBox(height: 14),
            ],
            PriceDetailCard(detail: detail),
            const SizedBox(height: 14),
            if (detail.payments.isNotEmpty) ...[
              BookingPaymentInfoCard(payment: detail.payments.first),
              const SizedBox(height: 14),
            ],
            BookingHistoryCard(statusHistory: detail.statusHistory),
            const SizedBox(height: 14),
            if (detail.note?.isNotEmpty == true) ...[
              BookingNoteCard(note: detail.note!),
              const SizedBox(height: 14),
            ],
            _buildActions(context, detail, fmt),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, BookingDetailModel d, NumberFormat fmt) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⬇️ Đang tải hóa đơn...'))),
            icon: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryLightBrand, size: 18),
            label: const Text('Tải hóa đơn PDF', style: TextStyle(color: AppColors.primaryLightBrand, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryLightBrand),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (d.canReview)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WriteReviewPage(bookingId: d.id, venueName: d.venueName),
                ),
              ),
              icon: const Icon(Icons.star_rounded, color: AppColors.white, size: 18),
              label: const Text('Viết đánh giá', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        if (d.canCancel) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CancelBookingPage(booking: d),
                ),
              ),
              icon: const Icon(Icons.cancel_outlined, color: AppColors.error, size: 18),
              label: const Text('Hủy đặt sân', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showQRModal(BuildContext context, String code) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('Mã QR Check-in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.qr_code_2_rounded, size: 200, color: AppColors.textPrimary),
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.primaryLightBrand, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.sports_soccer_rounded, color: AppColors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Mã: $code', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand, letterSpacing: 4)),
            const SizedBox(height: 8),
            const Text('Xuất trình cho nhân viên khi đến sân', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  (Color, Color, IconData) _statusStyle(BookingStatus s) {
    switch (s) {
      case BookingStatus.PENDING: return (AppColors.warning, AppColors.warning.withOpacity(0.12), Icons.schedule_rounded);
      case BookingStatus.CONFIRMED: return (AppColors.primaryLightBrand, AppColors.primaryLightBrand.withOpacity(0.1), Icons.check_circle_rounded);
      case BookingStatus.CHECKED_IN: return (AppColors.info, AppColors.info.withOpacity(0.1), Icons.play_circle_rounded);
      case BookingStatus.COMPLETED: return (AppColors.success, AppColors.success.withOpacity(0.1), Icons.task_alt_rounded);
      case BookingStatus.CANCELLED: return (AppColors.error, AppColors.error.withOpacity(0.1), Icons.cancel_rounded);
      case BookingStatus.NO_SHOW: return (AppColors.greyDark, AppColors.greyDark.withOpacity(0.1), Icons.person_off_rounded);
    }
  }
}
