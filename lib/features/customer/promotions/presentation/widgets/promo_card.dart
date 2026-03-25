import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';

class PromoCard extends StatelessWidget {
  final PromotionModel promo;
  final NumberFormat fmt;
  final VoidCallback onSave;

  const PromoCard({
    super.key,
    required this.promo,
    required this.fmt,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = promo.daysLeft;
    final isUrgent = daysLeft <= 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // ── Left accent ──
              Container(
                width: 6,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryLightBrand,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // discount badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.primaryLightBrand.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          promo.discountType ==
                                  PromotionDiscountType.PERCENTAGE
                              ? 'Giảm ${promo.discountValue.toStringAsFixed(0)}%'
                              : 'Giảm ${fmt.format(promo.discountValue)}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryLightBrand),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(promo.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      if (promo.description != null) ...[
                        const SizedBox(height: 3),
                        Text(promo.description!,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondary),
                            maxLines: 2),
                      ],
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.event_available_rounded,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text('Còn $daysLeft ngày',
                            style: TextStyle(
                                fontSize: 11,
                                color:
                                    isUrgent ? AppColors.error : AppColors.textHint,
                                fontWeight: isUrgent
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        const SizedBox(width: 12),
                        const Icon(Icons.shopping_cart_outlined,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text('Từ ${fmt.format(promo.minBookingAmount)}',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textHint)),
                      ]),
                    ],
                  ),
                ),
              ),
              // ── Save button ──
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onSave();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: AppColors.primaryLightBrand,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.bookmark_add_rounded,
                          color: AppColors.white, size: 18),
                      SizedBox(height: 2),
                      Text('Lưu',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          // Code tag
          Positioned(
            top: 8,
            right: 60,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: promo.code));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('📋 Đã sao chép "${promo.code}"'),
                    duration: const Duration(seconds: 1)));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: AppColors.mutedLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.borderLight, style: BorderStyle.solid)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(promo.code,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5)),
                  const SizedBox(width: 4),
                  const Icon(Icons.copy_rounded, size: 10, color: AppColors.textHint),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
