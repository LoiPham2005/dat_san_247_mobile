import 'package:flutter/material.dart';
import '../../../../design/theme/styles/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showIcon;
  final bool centerAlign;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showIcon = true,
    this.centerAlign = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (showIcon) ...[
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLightBrand,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.sports_soccer,
                size: 40,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          textAlign: centerAlign ? TextAlign.center : TextAlign.start,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: centerAlign ? 1.0 : 1.5,
            ),
            textAlign: centerAlign ? TextAlign.center : TextAlign.start,
          ),
        ],
      ],
    );
  }
}
