import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class IconBadges extends StatelessWidget {
  const IconBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
        badgeContent: const Text(
          '0',
          style: TextStyle(color: Colors.white),
        ),
        position: badges.BadgePosition.topStart(
          top: 2,
          start: 15,
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.orange,
        ),
        child: const Icon(Icons.card_travel));
  }
}
