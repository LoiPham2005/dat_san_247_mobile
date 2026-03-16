import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/shared/promotion/data/models/promotion_model.dart';
import 'package:intl/intl.dart';

class HomeActivePromotions extends StatelessWidget {
  final List<PromotionModel> promotions;
  final Function(PromotionModel) onPromotionTap;

  const HomeActivePromotions({
    super.key,
    required this.promotions,
    required this.onPromotionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Khuyến mãi tốt nhất',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: promotions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final promotion = promotions[index];
              return _buildPromotionCard(context, promotion);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCard(BuildContext context, PromotionModel promotion) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final String discountStr = promotion.discountType == PromotionDiscountType.FIXED_AMOUNT
        ? currencyFormat.format(promotion.discountValue)
        : '${promotion.discountValue.toInt()}%';

    return GestureDetector(
      onTap: () => onPromotionTap(promotion),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: AppColors.primaryLightBrand,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(Icons.local_offer_rounded, size: 100, color: AppColors.white.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'GIẢM\n$discountStr',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primaryLightBrand,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          promotion.name,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Mã: ${promotion.code}',
                            style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'HSD: ${DateFormat('dd/MM/yyyy').format(promotion.validTo)}',
                          style: TextStyle(color: AppColors.white.withOpacity(0.8), fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
