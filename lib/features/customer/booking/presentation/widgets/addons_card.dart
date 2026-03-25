import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_models.dart';

class AddonsCard extends StatelessWidget {
  final List<VenueServiceModel> services;
  final List<BookingAddonModel> selectedAddons;
  final Function(VenueServiceModel) onToggle;

  const AddonsCard({
    super.key,
    required this.services,
    required this.selectedAddons,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.add_shopping_cart_rounded, 'Dịch vụ kèm theo'),
          const SizedBox(height: 4),
          const Text('Tùy chọn thêm dịch vụ từ sân',
              style: TextStyle(color: AppColors.textHint, fontSize: 12)),
          const SizedBox(height: 12),
          ...services.map((service) {
            final isSelected = selectedAddons.any((a) => a.serviceId == service.id);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLightBrand.withOpacity(0.06)
                    : AppColors.mutedLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryLightBrand
                      : AppColors.borderLight,
                ),
              ),
              child: ListTile(
                dense: true,
                title: Text(service.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryLightBrand
                            : AppColors.textPrimary)),
                subtitle: Text(
                    fmt.format(service.price) +
                        '/${service.unit == 'UNIT' ? 'cái' : 'buổi'}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                trailing: GestureDetector(
                  onTap: () => onToggle(service),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primaryLightBrand
                          : AppColors.white,
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primaryLightBrand
                              : AppColors.borderLight,
                          width: 2),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: AppColors.white)
                        : null,
                  ),
                ),
              ),
            );
          }),
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
