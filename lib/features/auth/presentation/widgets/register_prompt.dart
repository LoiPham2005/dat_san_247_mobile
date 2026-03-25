import 'package:flutter/material.dart';
import '../../../../design/theme/styles/app_colors.dart';
import 'package:go_router/go_router.dart';

class RegisterPrompt extends StatelessWidget {
  const RegisterPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chưa có tài khoản?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () {
            context.push('/register');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Đăng ký ngay',
            style: TextStyle(
              color: AppColors.primaryLightBrand,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
