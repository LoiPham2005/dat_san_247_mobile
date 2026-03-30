import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/deals/data/models/promotion_model.dart';
import 'dashed_line_painter.dart';

class VoucherCard extends StatelessWidget {
  final PromotionModel promotion;
  const VoucherCard({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    // Format discount value based on type
    final discountStr = promotion.discountType == PromotionDiscountType.percentage
        ? '${promotion.discountValue.toInt()}%'
        : NumberFormat.compactCurrency(symbol: '', decimalDigits: 0).format(promotion.discountValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left portion - Icon/Discount
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryLightBrand.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                   Icons.local_offer_rounded,
                  color: AppColors.primaryLightBrand,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                   'Giảm $discountStr',
                  style: const TextStyle(
                    color: AppColors.primaryLightBrand,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Dashed divider line
          CustomPaint(
            size: const Size(1, double.infinity),
            painter: DashedLinePainter(),
          ),

          // Right portion - Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promotion.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    promotion.description ?? 'Ưu đãi đặc biệt dành cho bạn',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 12, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            'Hết hạn: ${DateFormat('dd/MM/yyyy').format(promotion.validTo)}',
                            style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightBrand,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Sử dụng',
                          style: TextStyle(
                              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
