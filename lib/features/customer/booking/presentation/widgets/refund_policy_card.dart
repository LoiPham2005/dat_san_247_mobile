import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_models.dart';

class RefundPolicyCard extends StatelessWidget {
  final List<RefundRuleModel> refundRules;

  const RefundPolicyCard({super.key, required this.refundRules});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.policy_rounded, 'Chính sách hoàn tiền'),
          const SizedBox(height: 12),
          ...refundRules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 5, right: 8),
                      decoration: const BoxDecoration(
                          color: AppColors.primaryLightBrand,
                          shape: BoxShape.circle),
                    ),
                    Expanded(
                        child: Text(rule.description ?? '',
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary))),
                  ],
                ),
              )),
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
