import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'dashed_line_painter.dart';

class VoucherCard extends StatelessWidget {
  final int index;
  const VoucherCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              color: AppColors.primaryLightBrand.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  index % 2 == 0 ? Icons.sports_soccer_rounded : Icons.sports_tennis_rounded,
                  color: AppColors.primaryLightBrand,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  index % 2 == 0 ? 'Giảm 20k' : 'Giảm 15%',
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
                    index % 2 == 0 ? 'Ưu đãi sân cỏ nhân tạo' : 'Voucher đặc biệt cuối tuần',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cho tất cả các khung giờ từ thứ 2 - 6',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
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
                            'Hết hạn: 31/12',
                            style: TextStyle(color: AppColors.textHint, fontSize: 10),
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
                          'Lưu',
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
