import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

class BookingCodeStatusCard extends StatelessWidget {
  final BookingDetailModel detail;
  final Color statusColor;
  final Color statusBg;
  final IconData statusIcon;

  const BookingCodeStatusCard({
    super.key,
    required this.detail,
    required this.statusColor,
    required this.statusBg,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 13, color: statusColor),
                    const SizedBox(width: 4),
                    Text(detail.status.label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor)),
                  ],
                ),
              ),
              const Spacer(),
              Text(DateFormat('dd/MM/yyyy').format(detail.createdAt),
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Clipboard.setData(ClipboardData(text: detail.bookingCode));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('📋 Đã sao chép mã booking'),
                  duration: Duration(seconds: 1)));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: AppColors.primaryLightBrand.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(detail.bookingCode,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryLightBrand,
                          letterSpacing: 2)),
                  const SizedBox(width: 8),
                  const Icon(Icons.copy_rounded,
                      size: 16, color: AppColors.primaryLightBrand),
                ],
              ),
            ),
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
}
