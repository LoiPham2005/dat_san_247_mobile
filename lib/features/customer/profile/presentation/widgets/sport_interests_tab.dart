import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/profile/data/models/profile_models.dart';
import 'setting_card.dart';
import 'skill_row.dart';

class SportInterestsTab extends StatelessWidget {
  final UserModel user;
  final Function(String sport, int level) onSkillChanged;
  final VoidCallback onSave;

  const SportInterestsTab({
    super.key,
    required this.user,
    required this.onSkillChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final prefs = user.profile?.sportPreferences ?? [];
    final allSports = [
      'FOOTBALL',
      'FUTSAL',
      'BADMINTON',
      'TENNIS',
      'PICKLEBALL',
      'BASKETBALL',
      'VOLLEYBALL',
    ];
    final selectedSports = prefs.map((p) => p.sportType).toSet();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingCard(
            title: 'Môn thể thao yêu thích',
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn các môn bạn yêu thích để nhận gợi ý sân phù hợp:',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allSports.map((sport) {
                        final sel = selectedSports.contains(sport);
                        return GestureDetector(
                          onTap: () => HapticFeedback.selectionClick(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primaryLightBrand.withOpacity(0.1)
                                  : AppColors.mutedLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? AppColors.primaryLightBrand : AppColors.borderLight,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_sportEmoji(sport), style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text(
                                  _sportLabel(sport),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: sel
                                        ? AppColors.primaryLightBrand
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Skill levels for selected sports
          if (prefs.isNotEmpty) ...[
            SettingCard(
              title: 'Trình độ của bạn',
              children: [
                ...prefs.map(
                  (pref) => SkillRow(
                    sport: pref.sportType,
                    skillLevel: pref.skillLevel,
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Lưu sở thích',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _sportEmoji(String sport) {
    return switch (sport.toUpperCase()) {
      'FOOTBALL' => '⚽',
      'FUTSAL' => '🥅',
      'BADMINTON' => '🏸',
      'TENNIS' => '🎾',
      'PICKLEBALL' => '🏓',
      'BASKETBALL' => '🏀',
      'VOLLEYBALL' => '🏐',
      _ => '🏅',
    };
  }

  String _sportLabel(String sport) {
    return switch (sport.toUpperCase()) {
      'FOOTBALL' => 'Bóng đá',
      'FUTSAL' => 'Futsal',
      'BADMINTON' => 'Cầu lông',
      'TENNIS' => 'Tennis',
      'PICKLEBALL' => 'Pickleball',
      'BASKETBALL' => 'Bóng rổ',
      'VOLLEYBALL' => 'Bóng chuyền',
      _ => sport,
    };
  }
}
