import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class PriceSummaryCard extends StatelessWidget {
  final double subTotal;
  final double addonTotal;
  final double discountAmount;
  final double totalAmount;
  final int selectedSlotsCount;
  final bool hasAppliedPromo;

  const PriceSummaryCard({
    super.key,
    required this.subTotal,
    required this.addonTotal,
    required this.discountAmount,
    required this.totalAmount,
    required this.selectedSlotsCount,
    required this.hasAppliedPromo,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _priceRow('Tiền sân (${selectedSlotsCount}h)', fmt.format(subTotal)),
          if (addonTotal > 0) _priceRow('Dịch vụ kèm theo', fmt.format(addonTotal)),
          if (hasAppliedPromo)
            _priceRow('Giảm giá', '-${fmt.format(discountAmount)}',
                isDiscount: true),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng thanh toán',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              Text(fmt.format(totalAmount),
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryLightBrand)),
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

  Widget _priceRow(String label, String value, {bool isDiscount = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary)),
            Text(value,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDiscount
                        ? AppColors.primaryLightBrand
                        : AppColors.textPrimary)),
          ],
        ),
      );
}
