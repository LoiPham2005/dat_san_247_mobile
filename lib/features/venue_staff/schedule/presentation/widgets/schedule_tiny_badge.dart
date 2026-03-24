import 'package:flutter/material.dart';

class ScheduleTinyBadge extends StatelessWidget {
  final String text;
  final Color color;
  const ScheduleTinyBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration:
            BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
        child:
            Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
      );
}
