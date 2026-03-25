import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_models.dart';

class PromoCard extends StatelessWidget {
  final PromotionModel? appliedPromo;
  final TextEditingController controller;
  final bool isApplying;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const PromoCard({
    super.key,
    required this.appliedPromo,
    required this.controller,
    required this.isApplying,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.local_offer_rounded, 'Mã giảm giá'),
          const SizedBox(height: 12),
          if (appliedPromo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLightBrand.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryLightBrand),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primaryLightBrand, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(appliedPromo!.name,
                        style: const TextStyle(
                            color: AppColors.primaryLightBrand,
                            fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    onTap: onRemove,
                    child: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.primaryLightBrand),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Nhập mã khuyến mãi...',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      filled: true,
                      fillColor: AppColors.mutedLight,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isApplying ? null : onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    elevation: 0,
                  ),
                  child: isApplying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.white))
                      : const Text('Áp dụng',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
          color: AppColors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2))
    ],
  );

  Widget _sectionTitle(IconData icon, String title) => Row(
    children: [
      Icon(icon, color: AppColors.primaryLightBrand, size: 20),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary)),
    ],
  );
}
