import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/cubit/owner_booking_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_action_button.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_amount_row.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_detail_card.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_info_row.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-09: Chi Tiết Booking (Owner View)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerBookingDetailPage extends StatelessWidget {
  final String bookingId;
  final OwnerBookingModel booking;

  const OwnerBookingDetailPage({super.key, required this.bookingId, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OwnerBookingDetailCubit>()..init(booking),
      child: _OwnerBookingDetailView(bookingId: bookingId),
    );
  }
}

class _OwnerBookingDetailView extends StatefulWidget {
  final String bookingId;
  const _OwnerBookingDetailView({required this.bookingId});

  @override
  State<_OwnerBookingDetailView> createState() => _OwnerBookingDetailViewState();
}

class _OwnerBookingDetailViewState extends State<_OwnerBookingDetailView> {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerBookingDetailCubit, BaseState<OwnerBookingModel>>(
      listener: (context, state) {
        if (state.message != null) {
          toast.success(state.message!);
        }
        if (state.isFailure) {
          toast.error(state.error ?? 'Đã xảy ra lỗi');
        }
      },
      builder: (context, state) {
        final booking = state.data;
        if (booking == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        final statusColor = switch (booking.status) {
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
            // ── AppBar ──
            SliverAppBar(
              pinned: true,
              expandedHeight: 140,
              backgroundColor: _brand,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                  onPressed: () => Navigator.pop(context)),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [_brandDark, _brand],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
                  child: SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 46, 20, 0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(booking.bookingCode,
                                style: const TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                            Text(booking.customerName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 8),
                            Row(children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
                                  child: Row(children: [
                                    Text(booking.status.emoji, style: const TextStyle(fontSize: 11)),
                                    const SizedBox(width: 4),
                                    Text(booking.status.label,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold))
                                  ])),
                              const SizedBox(width: 10),
                              Text('${_fmtPrice(booking.totalAmount)} đ',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                            ]),
                          ]))),
                ),
                title: Text(booking.bookingCode,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),

            SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(children: [
                      // ── Booking info ──
                      BookingDetailCard(title: 'Thông Tin Đặt Sân', icon: Icons.event_rounded, color: _brand, children: [
                        BookingInfoRow(
                            icon: Icons.sports_soccer_rounded, label: 'Sân', value: booking.courtName, color: _brand),
                        BookingInfoRow(
                            icon: Icons.calendar_today_rounded,
                            label: 'Ngày',
                            value: DateFormat('dd/MM/yyyy EEE', 'vi').format(booking.bookingDate),
                            color: AppColors.textPrimary),
                        BookingInfoRow(
                            icon: Icons.access_time_rounded,
                            label: 'Giờ',
                            value:
                                '${booking.startTime} – ${booking.endTime} (${booking.totalHours.toStringAsFixed(1)}h)',
                            color: AppColors.textPrimary),
                        if (booking.note != null && booking.note!.isNotEmpty)
                          BookingInfoRow(
                              icon: Icons.notes_rounded, label: 'Ghi chú', value: booking.note!, color: AppColors.textHint),
                      ]),
                      const SizedBox(height: 10),

                      // ── Customer ──
                      BookingDetailCard(title: 'Khách Hàng', icon: Icons.person_rounded, color: AppColors.info, children: [
                        BookingInfoRow(
                            icon: Icons.person_rounded,
                            label: 'Họ tên',
                            value: booking.customerName,
                            color: AppColors.textPrimary),
                        if (booking.customerPhone != null)
                          BookingInfoRow(
                              icon: Icons.phone_rounded, label: 'SĐT', value: booking.customerPhone!, color: AppColors.info),
                        if (booking.checkInCode != null)
                          BookingInfoRow(
                              icon: Icons.qr_code_rounded,
                              label: 'Mã check-in',
                              value: booking.checkInCode!,
                              color: _brand),
                      ]),
                      const SizedBox(height: 10),

                      // ── Addons ──
                      if (booking.addons.isNotEmpty)
                        BookingDetailCard(
                            title: 'Dịch Vụ Đã Dùng (${booking.addons.length})',
                            icon: Icons.room_service_rounded,
                            color: AppColors.warning,
                            children: [
                              ...booking.addons.map((a) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(children: [
                                    const Icon(Icons.check_circle_outline_rounded,
                                        size: 14, color: AppColors.warning),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text('${a.serviceName} × ${a.quantity}',
                                            style: const TextStyle(fontSize: 12))),
                                    Text('${_fmtPrice(a.totalPrice)} đ',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ]))),
                            ]),
                      if (booking.addons.isNotEmpty) const SizedBox(height: 10),

                      // ── Payment breakdown ──
                      BookingDetailCard(title: 'Thanh Toán', icon: Icons.receipt_long_rounded, color: AppColors.success, children: [
                        BookingAmountRow(label: 'Tiền sân', amount: booking.subTotal),
                        if (booking.addons.isNotEmpty)
                          BookingAmountRow(
                              label: 'Dịch vụ', amount: booking.addons.fold(0.0, (sum, a) => sum + a.totalPrice)),
                        if (booking.discountAmount > 0)
                          BookingAmountRow(label: 'Giảm giá', amount: -booking.discountAmount, color: AppColors.success),
                        if (booking.vatAmount > 0) BookingAmountRow(label: 'VAT', amount: booking.vatAmount),
                        const Divider(height: 12, color: AppColors.borderLight),
                        BookingAmountRow(label: 'Tổng', amount: booking.totalAmount, bold: true),
                        const SizedBox(height: 6),
                        BookingAmountRow(label: 'Hoa hồng platform', amount: booking.commissionAmount, color: AppColors.error),
                        BookingAmountRow(label: 'Thực nhận', amount: booking.ownerReceives, bold: true, color: AppColors.success),
                      ]),
                      const SizedBox(height: 16),

                      // ── Action buttons ──
                      if (booking.canConfirm)
                        BookingActionButton(label: '✅ Xác Nhận Booking', color: AppColors.success, onTap: () => _confirmBooking(context, booking)),
                      if (booking.canCancel && booking.status != BookingStatus.PENDING)
                        const SizedBox(height: 10),
                      if (booking.canCancel)
                        BookingActionButton(
                            label: '❌ Hủy Booking',
                            color: AppColors.error,
                            onTap: () => _showCancelSheet(context, booking),
                            outlined: true),
                      const SizedBox(height: 20),
                    ]))),
          ]),
        );
      },
    );
  }

  void _confirmBooking(BuildContext context, OwnerBookingModel booking) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Xác nhận booking?', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('Xác nhận booking #${booking.bookingCode} cho ${booking.customerName}?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<OwnerBookingDetailCubit>().updateStatus(booking.id, 'CONFIRMED');
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Xác nhận', style: TextStyle(color: Colors.white))),
              ],
            ));
  }

  void _showCancelSheet(BuildContext context, OwnerBookingModel booking) {
    final reasonCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                            color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                const Icon(Icons.cancel_rounded, color: AppColors.error, size: 36),
                const SizedBox(height: 8),
                const Text('Hủy Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Booking #${booking.bookingCode}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                const SizedBox(height: 16),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3))),
                    child: const Text('Hủy booking có thể kích hoạt hoàn tiền theo chính sách đã thiết lập.',
                        style: TextStyle(fontSize: 11, color: AppColors.warning))),
                const SizedBox(height: 12),
                TextField(
                    controller: reasonCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                        labelText: 'Lý do hủy *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 16),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (reasonCtrl.text.isEmpty) return;
                        Navigator.pop(ctx);
                        context.read<OwnerBookingDetailCubit>().updateStatus(booking.id, 'CANCELLED');
                        HapticFeedback.mediumImpact();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Xác Nhận Hủy',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
              ]))),
    );
  }

  String _fmtPrice(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}
