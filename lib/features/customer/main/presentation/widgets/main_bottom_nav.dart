import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<MainNavItem> items;
  final ValueChanged<int> onTabTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              if (item.isCenter) {
                return _CenterButton(
                  isActive: currentIndex == index,
                  onTap: () => onTabTap(index),
                );
              }
              return _NavItem(
                item: item,
                isActive: currentIndex == index,
                onTap: () => onTabTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final MainNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  key: ValueKey(isActive),
                  size: 24,
                  color: isActive
                      ? AppColors.primaryLightBrand
                      : AppColors.textHint,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primaryLightBrand
                      : AppColors.textHint,
                ),
                child: Text(item.label),
              ),
              // Active indicator dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 4 : 0,
                height: 4,
                margin: const EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLightBrand,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CenterButton({
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive
                      ? [const Color(0xFF0F7A35), const Color(0xFF22C55E)]
                      : [AppColors.primaryLightBrand, const Color(0xFF22C55E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLightBrand
                        .withOpacity(isActive ? 0.5 : 0.3),
                    blurRadius: isActive ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                turns: isActive ? 0.08 : 0,
                child: const Icon(
                  Icons.sports_soccer_rounded,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Đặt sân',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color:
                    isActive ? AppColors.primaryLightBrand : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isCenter;

  const MainNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.isCenter = false,
  });
}
