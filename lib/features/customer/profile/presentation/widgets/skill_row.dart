import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class SkillRow extends StatelessWidget {
  final String sport;
  final int skillLevel;
  final ValueChanged<int> onChanged;

  const SkillRow({
    super.key,
    required this.sport,
    required this.skillLevel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _label(sport),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(
                5,
                (i) => Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(i + 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 6,
                      decoration: BoxDecoration(
                        color: i < skillLevel
                            ? AppColors.primaryLightBrand
                            : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _skillLabel(skillLevel),
              style: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ],
        ),
      );

  String _label(String sport) => switch (sport.toUpperCase()) {
        'FOOTBALL' => '⚽ Bóng đá',
        'BADMINTON' => '🏸 Cầu lông',
        'TENNIS' => '🎾 Tennis',
        _ => sport,
      };

  String _skillLabel(int level) => switch (level) {
        1 => 'Mới bắt đầu',
        2 => 'Cơ bản',
        3 => 'Trung bình',
        4 => 'Khá',
        _ => 'Chuyên nghiệp',
      };
}
