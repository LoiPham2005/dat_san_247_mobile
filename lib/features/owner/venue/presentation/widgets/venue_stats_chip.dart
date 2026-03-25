import 'package:flutter/material.dart';

class VenueStatsChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const VenueStatsChip({super.key, required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration:
            BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
        child: Text('$count $label',
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      );
}
