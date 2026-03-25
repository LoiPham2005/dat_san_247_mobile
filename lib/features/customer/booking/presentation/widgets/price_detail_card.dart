import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

class PriceDetailCard extends StatelessWidget {
  final BookingDetailModel detail;

  const PriceDetailCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.receipt_long_rounded, 'Chi tiết thanh toán'),
          const SizedBox(height: 12),
          _priceRow('Tiền sân', fmt.format(detail.subTotal)),
          if (detail.addons.isNotEmpty)
            _priceRow(
                'Dịch vụ',
                fmt.format(
                    detail.addons.fold(0.0, (s, a) => s + a.totalPrice))),
          if (detail.discountAmount > 0)
            _priceRow('Giảm giá', '-${fmt.format(detail.discountAmount)}',
                isDiscount: true),
          if (detail.vatAmount > 0)
            _priceRow(
                'VAT (${(detail.vatRate * 100).toStringAsFixed(0)}%)',
                fmt.format(detail.vatAmount)),
          const Divider(height: 20, color: AppColors.borderLight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng cộng',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(fmt.format(detail.totalAmount),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryLightBrand)),
            ],
          ),
          if (detail.refundAmount > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hoàn tiền',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                Text(fmt.format(detail.refundAmount),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.info)),
              ],
            ),
          ],
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

  Widget _priceRow(String label, String value, {bool isDiscount = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDiscount
                        ? const Color(0xFF16A34A)
                        : AppColors.textPrimary)),
          ],
        ),
      );
}
