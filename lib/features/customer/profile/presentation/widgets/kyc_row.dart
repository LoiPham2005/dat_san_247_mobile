import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/profile/data/models/profile_models.dart';

class KycRow extends StatelessWidget {
  final KycStatus status;
  final VoidCallback onTap;

  const KycRow({super.key, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == KycStatus.VERIFIED;
    return ListTile(
      dense: true,
      leading: Icon(
        isVerified ? Icons.verified_user_rounded : Icons.shield_outlined,
        color: isVerified ? AppColors.success : AppColors.warning,
        size: 22,
      ),
      title: Text(
        status.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isVerified ? AppColors.success : AppColors.warning,
        ),
      ),
      subtitle: Text(
        isVerified
            ? 'Tài khoản đã được xác minh danh tính'
            : 'Xác minh để mở khoá đầy đủ tính năng',
        style: const TextStyle(fontSize: 11, color: AppColors.textHint),
      ),
      trailing: isVerified
          ? null
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Xác minh',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
