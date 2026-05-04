import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/providers/booking_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-11: Hủy Đặt Sân
// ──────────────────────────────────────────────────────────────────────────
class CancelBookingPage extends HookConsumerWidget {
  final BookingDetailModel booking;
  final String bookingId;

  const CancelBookingPage({
    super.key,
    required this.booking,
    required this.bookingId,
  });

  static const _cancelReasons = [
    'Có kế hoạch khác đột xuất',
    'Thiếu người tham gia',
    'Thời tiết không thuận lợi',
    'Đặt nhầm ngày/giờ',
    'Vấn đề tài chính',
    'Lý do khác',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reasonController = useTextEditingController();
    final selectedReason = useState<String?>(null);

    final provider = bookingDetailProvider(bookingId);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final isSubmitting = state.isLoading;

    RiverpodListeners.async$(
      ref: ref,
      context: context,
      provider: provider,
      notifier: notifier,
      onSuccess: (_) {
        if (notifier.pendingSuccessMessage == null) return;
        if (context.canPop()) context.pop();
      },
    );

    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final now = DateTime.now();
    final bookingDateTime = DateTime(
      booking.bookingDate.year,
      booking.bookingDate.month,
      booking.bookingDate.day,
      int.parse(booking.startTime.split(':')[0]),
      int.parse(booking.startTime.split(':')[1]),
    );
    final hoursLeft = bookingDateTime.difference(now).inHours;
    final refundAmount = booking.computeRefundAmount(booking.totalAmount);
    final cancellationFee = booking.totalAmount - refundAmount;

    Future<void> submitCancel() async {
      final reason = selectedReason.value == 'Lý do khác'
          ? reasonController.text.trim()
          : selectedReason.value;
      if (reason == null || reason.isEmpty) {
        toast.error('Vui lòng chọn lý do hủy');
        return;
      }
      final confirmed = await _showConfirmDialog(
        context,
        fmt: fmt,
        totalAmount: booking.totalAmount,
        cancellationFee: cancellationFee,
        refundAmount: refundAmount,
      );
      if (!confirmed) return;
      await notifier.cancelBooking(reason);
    }

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
        title: const Text('Hủy đặt sân',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hoursLeft > 24
                              ? '⏰ Còn $hoursLeft giờ trước khi bắt đầu'
                              : hoursLeft > 0
                                  ? '⚠️ Còn $hoursLeft giờ nữa — phí hủy cao'
                                  : '🚫 Đã qua thời gian cho phép hủy',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.warning),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Hủy booking sẽ không thể hoàn tác. Tiền hoàn sẽ vào ví trong 5-15 phút.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thông tin đặt sân sẽ hủy',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  _row(Icons.stadium_rounded,
                      '${booking.courtName} - ${booking.venueName}'),
                  const SizedBox(height: 6),
                  _row(
                      Icons.calendar_today_rounded,
                      DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
                          .format(booking.bookingDate)),
                  const SizedBox(height: 6),
                  _row(Icons.access_time_rounded,
                      '${booking.startTime} – ${booking.endTime}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tính toán hoàn tiền',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  ...booking.refundRules.map((r) {
                    final isApplicable = hoursLeft >= r.cancelBeforeHours;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isApplicable
                            ? AppColors.primaryLightBrand.withOpacity(0.08)
                            : AppColors.mutedLight,
                        borderRadius: BorderRadius.circular(10),
                        border: isApplicable
                            ? Border.all(
                                color: AppColors.primaryLightBrand,
                                width: 1.5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isApplicable
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isApplicable
                                ? AppColors.primaryLightBrand
                                : AppColors.textHint,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              r.description ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: isApplicable
                                    ? AppColors.primaryLightBrand
                                    : AppColors.textSecondary,
                                fontWeight: isApplicable
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 16, color: AppColors.borderLight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bạn sẽ nhận lại',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        fmt.format(refundAmount),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: refundAmount > 0
                              ? AppColors.primaryLightBrand
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lý do hủy *',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _cancelReasons.map((reason) {
                      final isSelected = selectedReason.value == reason;
                      return GestureDetector(
                        onTap: () => selectedReason.value = reason,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryLightBrand.withOpacity(0.1)
                                : AppColors.mutedLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryLightBrand
                                  : AppColors.borderLight,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            reason,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primaryLightBrand
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (selectedReason.value == 'Lý do khác') ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Mô tả chi tiết lý do hủy...',
                        hintStyle: const TextStyle(
                            color: AppColors.textHint, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.mutedLight,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -4))
          ],
        ),
        child: ElevatedButton(
          onPressed: isSubmitting ? null : submitCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size(double.infinity, 52),
            elevation: 0,
          ),
          child: isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: AppColors.white))
              : const Text('Xác nhận hủy booking',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white)),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textHint),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary)),
          ),
        ],
      );

  BoxDecoration _cardDeco() => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)
        ],
      );

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required NumberFormat fmt,
    required double totalAmount,
    required double cancellationFee,
    required double refundAmount,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận hủy booking?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng tiền',
                          style: TextStyle(color: AppColors.textSecondary)),
                      Text(fmt.format(totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Phí hủy',
                          style: TextStyle(color: AppColors.error)),
                      Text('-${fmt.format(cancellationFee)}',
                          style: const TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hoàn tiền vào ví',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        fmt.format(refundAmount),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: refundAmount > 0
                              ? AppColors.primaryLightBrand
                              : AppColors.textHint,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Quay lại')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text('Xác nhận hủy',
                style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
