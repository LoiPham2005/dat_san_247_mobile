import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/providers/owner_booking_detail_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_action_button.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_amount_row.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_detail_card.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-09: Chi Tiết Booking (Owner View)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerBookingDetailPage extends ConsumerWidget {
  final String bookingId;
  final OwnerBookingModel booking;

  const OwnerBookingDetailPage({
    super.key,
    required this.bookingId,
    required this.booking,
  });

  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ownerBookingDetailProvider(booking);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    useAsyncValueListener(provider: provider, ref: ref);

    final current = state.value;
    if (current == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final statusColor = switch (current.status) {
      BookingStatus.PENDING => AppColors.warning,
      BookingStatus.CONFIRMED => AppColors.info,
      BookingStatus.CHECKED_IN => _brand,
      BookingStatus.COMPLETED => AppColors.success,
      BookingStatus.CANCELLED => AppColors.error,
      BookingStatus.NO_SHOW => AppColors.textHint,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 140,
          backgroundColor: _brand,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [_brandDark, _brand],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 46, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(current.bookingCode,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                      Text(current.customerName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3))),
                          child: Row(children: [
                            Text(current.status.emoji, style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 4),
                            Text(current.status.label,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ),
                        const SizedBox(width: 10),
                        Text('${_fmtPrice(current.totalAmount)} đ',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            title: Text(current.bookingCode,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              BookingDetailCard(
                title: 'Thông Tin Đặt Sân',
                icon: Icons.event_rounded,
                color: _brand,
                children: [
                  BookingInfoRow(
                      icon: Icons.sports_soccer_rounded,
                      label: 'Sân',
                      value: current.courtName,
                      color: _brand),
                  BookingInfoRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Ngày',
                      value: DateFormat('dd/MM/yyyy EEE', 'vi')
                          .format(current.bookingDate),
                      color: AppColors.textPrimary),
                  BookingInfoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Giờ',
                      value:
                          '${current.startTime} – ${current.endTime} (${current.totalHours.toStringAsFixed(1)}h)',
                      color: AppColors.textPrimary),
                  if (current.note != null && current.note!.isNotEmpty)
                    BookingInfoRow(
                        icon: Icons.notes_rounded,
                        label: 'Ghi chú',
                        value: current.note!,
                        color: AppColors.textHint),
                ],
              ),
              const SizedBox(height: 10),
              BookingDetailCard(
                title: 'Khách Hàng',
                icon: Icons.person_rounded,
                color: AppColors.info,
                children: [
                  BookingInfoRow(
                      icon: Icons.person_rounded,
                      label: 'Họ tên',
                      value: current.customerName,
                      color: AppColors.textPrimary),
                  if (current.customerPhone != null)
                    BookingInfoRow(
                        icon: Icons.phone_rounded,
                        label: 'SĐT',
                        value: current.customerPhone!,
                        color: AppColors.info),
                  if (current.checkInCode != null)
                    BookingInfoRow(
                        icon: Icons.qr_code_rounded,
                        label: 'Mã check-in',
                        value: current.checkInCode!,
                        color: _brand),
                ],
              ),
              const SizedBox(height: 10),
              if (current.addons.isNotEmpty)
                BookingDetailCard(
                  title: 'Dịch Vụ Đã Dùng (${current.addons.length})',
                  icon: Icons.room_service_rounded,
                  color: AppColors.warning,
                  children: [
                    ...current.addons.map((a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(children: [
                            const Icon(Icons.check_circle_outline_rounded,
                                size: 14, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text('${a.serviceName} × ${a.quantity}',
                                    style: const TextStyle(fontSize: 12))),
                            Text('${_fmtPrice(a.totalPrice)} đ',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ]),
                        )),
                  ],
                ),
              if (current.addons.isNotEmpty) const SizedBox(height: 10),
              BookingDetailCard(
                title: 'Thanh Toán',
                icon: Icons.receipt_long_rounded,
                color: AppColors.success,
                children: [
                  BookingAmountRow(label: 'Tiền sân', amount: current.subTotal),
                  if (current.addons.isNotEmpty)
                    BookingAmountRow(
                        label: 'Dịch vụ',
                        amount: current.addons
                            .fold(0.0, (sum, a) => sum + a.totalPrice)),
                  if (current.discountAmount > 0)
                    BookingAmountRow(
                        label: 'Giảm giá',
                        amount: -current.discountAmount,
                        color: AppColors.success),
                  if (current.vatAmount > 0)
                    BookingAmountRow(label: 'VAT', amount: current.vatAmount),
                  const Divider(height: 12, color: AppColors.borderLight),
                  BookingAmountRow(
                      label: 'Tổng', amount: current.totalAmount, bold: true),
                  const SizedBox(height: 6),
                  BookingAmountRow(
                      label: 'Hoa hồng platform',
                      amount: current.commissionAmount,
                      color: AppColors.error),
                  BookingAmountRow(
                      label: 'Thực nhận',
                      amount: current.ownerReceives,
                      bold: true,
                      color: AppColors.success),
                ],
              ),
              const SizedBox(height: 16),
              if (current.canConfirm)
                BookingActionButton(
                  label: '✅ Xác Nhận Booking',
                  color: AppColors.success,
                  onTap: () => _confirmBooking(context, notifier, current),
                ),
              if (current.canCancel && current.status != BookingStatus.PENDING)
                const SizedBox(height: 10),
              if (current.canCancel)
                BookingActionButton(
                  label: '❌ Hủy Booking',
                  color: AppColors.error,
                  onTap: () => _showCancelSheet(context, notifier, current),
                  outlined: true,
                ),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ]),
    );
  }

  void _confirmBooking(
    BuildContext context,
    OwnerBookingDetailNotifier notifier,
    OwnerBookingModel booking,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận booking?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            'Xác nhận booking #${booking.bookingCode} cho ${booking.customerName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              notifier.updateStatus(booking.id, 'CONFIRMED');
              HapticFeedback.mediumImpact();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCancelSheet(
    BuildContext context,
    OwnerBookingDetailNotifier notifier,
    OwnerBookingModel booking,
  ) {
    final reasonCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 14),
            const Icon(Icons.cancel_rounded, color: AppColors.error, size: 36),
            const SizedBox(height: 8),
            const Text('Hủy Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Booking #${booking.bookingCode}',
                style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Hủy booking có thể kích hoạt hoàn tiền theo chính sách đã thiết lập.',
                style: TextStyle(fontSize: 11, color: AppColors.warning),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'Lý do hủy *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (reasonCtrl.text.isEmpty) return;
                  Navigator.pop(ctx);
                  notifier.updateStatus(booking.id, 'CANCELLED');
                  HapticFeedback.mediumImpact();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Xác Nhận Hủy',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  String _fmtPrice(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}
