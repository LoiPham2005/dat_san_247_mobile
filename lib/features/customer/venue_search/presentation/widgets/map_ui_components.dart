import 'package:flutter/material.dart';

class MapFloatBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const MapFloatBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.17), blurRadius: 12)],
          ),
          child: Icon(icon, color: const Color(0xFF2C3E50), size: 21),
        ),
      );
}

class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(color: const Color(0xFF16A34A).withValues(alpha: 0.4), blurRadius: 8)
            ],
          ),
        ),
      ],
    );
  }
}

class MapDragHandle extends StatelessWidget {
  final VoidCallback onTap;
  const MapDragHandle({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE3EA),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
}
