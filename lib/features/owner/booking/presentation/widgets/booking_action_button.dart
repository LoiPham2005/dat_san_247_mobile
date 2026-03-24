import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;
  const BookingActionButton(
      {super.key,
      required this.label,
      required this.color,
      required this.onTap,
      this.outlined = false});

  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onTap();
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)))
          : ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onTap();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
}
