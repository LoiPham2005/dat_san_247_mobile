import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class PaymentMethodCard extends StatelessWidget {
  final String selectedPayment;
  final List<Map<String, String>> paymentMethods;
  final ValueChanged<String> onChanged;

  const PaymentMethodCard({
    super.key,
    required this.selectedPayment,
    required this.paymentMethods,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.payment_rounded, 'Phương thức thanh toán'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: paymentMethods.map((pm) {
              final isSelected = selectedPayment == pm['id'];
              return GestureDetector(
                onTap: () => onChanged(pm['id']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLightBrand.withOpacity(0.1)
                        : AppColors.mutedLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSelected
                            ? AppColors.primaryLightBrand
                            : AppColors.borderLight,
                        width: isSelected ? 2 : 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pm['icon']!, style: const TextStyle(fontSize: 18)),
                      Text(pm['label']!,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primaryLightBrand
                                  : AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }).toList(),
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
