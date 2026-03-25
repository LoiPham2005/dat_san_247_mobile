import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class ReferralRow extends StatelessWidget {
  final String code;
  const ReferralRow({super.key, required this.code});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mã giới thiệu của bạn',
              style: TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightBrand.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.primaryLightBrand.withOpacity(0.3)),
                    ),
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryLightBrand,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('📋 Đã sao chép "$code"'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightBrand,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.copy_rounded,
                        color: AppColors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Chia sẻ mã này với bạn bè để cả hai nhận ưu đãi!',
              style: TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ],
        ),
      );
}
