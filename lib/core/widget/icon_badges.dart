import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:dat_san_247_mobile/core/styles/color_app.dart';

class IconBadges extends StatelessWidget {
  const IconBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: badges.Badge(
          badgeContent: Text(
            "0",
            style: TextStyle(color: ColorApp.white),
          ),
          position: badges.BadgePosition.topStart(
            top: 2,
            start: 15,
          ),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Colors.orange,
          ),
          child: Icon(Icons.card_travel)),
    );
  }
}
