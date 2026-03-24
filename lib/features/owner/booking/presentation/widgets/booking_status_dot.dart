import 'package:flutter/material.dart';

class BookingStatusDot extends StatelessWidget {
  final Color color;
  final String label;
  const BookingStatusDot({super.key, required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold))
      ]);
}
