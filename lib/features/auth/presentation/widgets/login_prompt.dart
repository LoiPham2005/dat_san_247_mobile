import 'package:flutter/material.dart';
import '../../../../design/theme/styles/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/config/route_names.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Đã có tài khoản?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.login);
            }
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Đăng nhập',
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
