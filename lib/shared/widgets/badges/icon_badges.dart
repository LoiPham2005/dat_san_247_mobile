import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

/// Icon với badge count
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.count,
    this.onTap,
    this.color,
    this.badgeColor,
    this.iconSize,
    this.showZero = false,
  });

  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  final Color? color;
  final Color? badgeColor;
  final double? iconSize;
  final bool showZero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showBadge = showZero ? count >= 0 : count > 0;

    final child = GestureDetector(
      onTap: onTap,
      child: badges.Badge(
        showBadge: showBadge,
        badgeContent: Text(
          count > 99 ? '99+' : '$count',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        position: badges.BadgePosition.topEnd(top: -4, end: -4),
        badgeStyle: badges.BadgeStyle(
          badgeColor: badgeColor ?? theme.colorScheme.error,
        ),
        child: Icon(icon, size: iconSize, color: color),
      ),
    );

    return child;
  }
}
