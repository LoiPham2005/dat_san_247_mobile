import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/user_voucher_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoucherCard extends StatelessWidget {
  final UserVoucherModel voucher;
  final NumberFormat fmt;
  final bool dimmed;

  const VoucherCard({
    super.key,
    required this.voucher,
    required this.fmt,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final promo = voucher.promotion;
    final (statusColor, statusLabel) = _voucherStatus(voucher.status);

    return Opacity(
      opacity: dimmed ? 0.55 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)
            ]),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 100,
              decoration: BoxDecoration(
                color: dimmed ? AppColors.greyLight : AppColors.primaryLightBrand,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(promo.name,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(statusLabel,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor)),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text(
                      promo.discountType == PromotionDiscountType.PERCENTAGE
                          ? 'Giảm ${promo.discountValue.toStringAsFixed(0)}%${promo.maxDiscountAmount != null ? ' tối đa ${fmt.format(promo.maxDiscountAmount!)}' : ''}'
                          : 'Giảm ${fmt.format(promo.discountValue)}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryLightBrand),
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.tag_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 3),
                      Text(promo.code,
                          style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5)),
                      if (voucher.expiresAt != null) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.schedule_rounded,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text(
                            'HSD: ${DateFormat('dd/MM/yyyy').format(voucher.expiresAt!)}',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textHint)),
                      ],
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, String) _voucherStatus(VoucherStatus s) {
    return switch (s) {
      VoucherStatus.UNUSED => (AppColors.primaryLightBrand, 'Chưa dùng'),
      VoucherStatus.USED => (AppColors.textHint, 'Đã dùng'),
      VoucherStatus.EXPIRED => (AppColors.error, 'Hết hạn'),
    };
  }
}
