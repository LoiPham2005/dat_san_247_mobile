import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final NumberFormat fmt;
  final VoidCallback onTap;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.fmt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (color, bg, icon) = _statusStyle(invoice.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: bg, borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(icon, size: 11, color: color),
                    const SizedBox(width: 4),
                    Text(invoice.status.label,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ]),
                ),
                const Spacer(),
                Text(invoice.invoiceNumber,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 10),
            Text('${invoice.bookings.venues.name} · ${invoice.bookings.bookingCode}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(DateFormat('dd/MM/yyyy').format(invoice.bookings.bookingDate),
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fmt.format(invoice.amount),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryLightBrand)),
                const Row(children: [
                  Icon(Icons.chevron_right_rounded,
                      color: AppColors.textHint, size: 18),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color, IconData) _statusStyle(InvoiceStatus s) {
    switch (s) {
      case InvoiceStatus.DRAFT:
        return (AppColors.textHint, AppColors.mutedLight, Icons.edit_note);
      case InvoiceStatus.ISSUED:
        return (
          AppColors.warning,
          AppColors.warning.withOpacity(0.12),
          Icons.receipt_outlined
        );
      case InvoiceStatus.PAID:
        return (
          AppColors.success,
          AppColors.success.withOpacity(0.1),
          Icons.check_circle_rounded
        );
      case InvoiceStatus.VOID:
        return (AppColors.textHint, AppColors.mutedLight, Icons.cancel_outlined);
      case InvoiceStatus.REFUNDED:
        return (AppColors.info, AppColors.info.withOpacity(0.1), Icons.undo_rounded);
    }
  }
}
