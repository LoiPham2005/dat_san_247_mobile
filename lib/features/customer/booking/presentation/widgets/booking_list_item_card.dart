import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

class BookingListItemCard extends StatelessWidget {
  final BookingListItemModel booking;
  final VoidCallback onTap;

  const BookingListItemCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateStr = DateFormat('dd/MM/yyyy').format(booking.bookingDate);
    final (color, bg, icon) = _statusStyle(booking.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: booking.venueThumbnailUrl != null
                        ? Image.network(booking.venueThumbnailUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _missingThumb())
                        : _missingThumb(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.venueName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(booking.courtName,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: bg, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 10, color: color),
                        const SizedBox(width: 3),
                        Text(booking.status.label,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: color)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.borderLight),

            // ── Info Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  _InfoChip(icon: Icons.calendar_today_rounded, label: dateStr),
                  const SizedBox(width: 10),
                  _InfoChip(
                      icon: Icons.access_time_rounded,
                      label: '${booking.startTime}–${booking.endTime}'),
                  const Spacer(),
                  Text(fmt.format(booking.totalAmount),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryLightBrand)),
                ],
              ),
            ),

            // ── Action strip (QR code for CONFIRMED) ──
            if (booking.status == BookingStatus.CONFIRMED &&
                booking.checkInCode != null)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(ClipboardData(text: booking.checkInCode!));
                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text('✅ Đã sao chép mã check-in'),
                  //     duration: Duration(seconds: 1)));
                  toast.success('Đã sao chép mã check-in');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightBrand.withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2_rounded,
                          size: 16, color: AppColors.primaryLightBrand),
                      const SizedBox(width: 6),
                      Text('Mã check-in: ${booking.checkInCode}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLightBrand)),
                      const SizedBox(width: 4),
                      const Icon(Icons.copy_rounded,
                          size: 12, color: AppColors.primaryLightBrand),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _missingThumb() => Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
            color: AppColors.mutedLight,
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.sports_soccer_rounded,
            color: AppColors.primaryLightBrand, size: 28),
      );

  (Color, Color, IconData) _statusStyle(BookingStatus s) {
    switch (s) {
      case BookingStatus.PENDING:
        return (
          AppColors.warning,
          AppColors.warning.withOpacity(0.12),
          Icons.schedule_rounded
        );
      case BookingStatus.CONFIRMED:
        return (
          AppColors.primaryLightBrand,
          AppColors.primaryLightBrand.withOpacity(0.1),
          Icons.check_circle_rounded
        );
      case BookingStatus.CHECKED_IN:
        return (
          AppColors.info,
          AppColors.info.withOpacity(0.1),
          Icons.play_circle_rounded
        );
      case BookingStatus.COMPLETED:
        return (
          AppColors.success,
          AppColors.success.withOpacity(0.1),
          Icons.task_alt_rounded
        );
      case BookingStatus.CANCELLED:
        return (
          AppColors.error,
          AppColors.error.withOpacity(0.1),
          Icons.cancel_rounded
        );
      case BookingStatus.NO_SHOW:
        return (
          AppColors.greyDark,
          AppColors.greyDark.withOpacity(0.1),
          Icons.person_off_rounded
        );
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 3),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
