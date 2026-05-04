import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/app_theme.dart';
import 'package:dat_san_247_mobile/design/theme/providers/theme_notifier.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_color_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemePicker extends ConsumerWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    return AlertDialog(
      title: const Text('🎨 Chọn Theme'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Color Selection
            Text('Màu sắc', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 12.h),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: AppTheme.allThemes.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final themeType = AppTheme.allThemes[index];
                final isSelected = state.palette == themeType;

                return _ThemeColorButton(
                  themeType: themeType,
                  isSelected: isSelected,
                  onTap: () => notifier.changePalette(themeType),
                );
              },
            ),
            SizedBox(height: 24.h),

            // ✅ Mode Selection (Light/Dark/System)
            Text('Chế độ', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _ModeButton(
                    mode: AppThemeMode.light,
                    icon: Icons.light_mode,
                    label: 'Light',
                    isSelected: state.themeMode == AppThemeMode.light,
                    onTap: () => notifier.changeMode(AppThemeMode.light),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _ModeButton(
                    mode: AppThemeMode.dark,
                    icon: Icons.dark_mode,
                    label: 'Dark',
                    isSelected: state.themeMode == AppThemeMode.dark,
                    onTap: () => notifier.changeMode(AppThemeMode.dark),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _ModeButton(
                    mode: AppThemeMode.system,
                    icon: Icons.brightness_auto,
                    label: 'System',
                    isSelected: state.themeMode == AppThemeMode.system,
                    onTap: () => notifier.changeMode(AppThemeMode.system),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
    );
  }
}

// ✅ Theme Color Button
class _ThemeColorButton extends StatelessWidget {
  final AppPalette themeType;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeColorButton({required this.themeType, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(themeType.icon, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              themeType.name.toUpperCase(),
              style: TextStyle(fontSize: 10.sp),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Theme Mode Button
class _ModeButton extends StatelessWidget {
  final AppThemeMode mode;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.mode,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
