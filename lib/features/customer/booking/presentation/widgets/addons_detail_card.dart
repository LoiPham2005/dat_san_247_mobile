import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

class AddonsDetailCard extends StatelessWidget {
  final List<BookingAddonDetailModel> addons;

  const AddonsDetailCard({super.key, required this.addons});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.add_shopping_cart_rounded, 'Dịch vụ kèm theo'),
          const SizedBox(height: 12),
          ...addons.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.mutedLight,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text('x${a.quantity}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(a.serviceName,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textPrimary))),
                    Text(fmt.format(a.totalPrice),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
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

  Widget _sectionHeader(IconData icon, String label) => Row(
    children: [
      Icon(icon, color: AppColors.primaryLightBrand, size: 18),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary)),
    ],
  );
}
