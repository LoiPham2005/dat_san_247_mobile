import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final NumberFormat fmt;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.fmt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isCredit = t.type.isCredit;
    final isFailed = t.status == TransactionStatus.FAILED;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFailed
                    ? AppColors.mutedLight
                    : (isCredit
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.primaryLightBrand.withOpacity(0.08)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _icon(t.type),
                color: isFailed
                    ? AppColors.textHint
                    : (isCredit
                        ? AppColors.success
                        : AppColors.primaryLightBrand),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.type.label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  Text(
                    t.description ??
                        (t.bookingCode != null
                            ? 'Booking #${t.bookingCode}'
                            : ''),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}${fmt.format(t.amount)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isFailed
                        ? AppColors.textHint
                        : (isCredit
                            ? AppColors.success
                            : AppColors.textPrimary),
                    decoration: isFailed ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(DateFormat('HH:mm').format(t.createdAt),
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textHint)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon(TransactionType t) {
    switch (t) {
      case TransactionType.DEPOSIT:
        return Icons.add_circle_outline_rounded;
      case TransactionType.PAYMENT:
        return Icons.sports_soccer_rounded;
      case TransactionType.REFUND:
        return Icons.undo_rounded;
      case TransactionType.PAYOUT:
        return Icons.arrow_upward_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }
}
