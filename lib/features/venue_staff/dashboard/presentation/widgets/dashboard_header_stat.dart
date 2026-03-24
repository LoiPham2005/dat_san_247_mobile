import 'package:flutter/material.dart';

class DashboardHeaderStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  const DashboardHeaderStat(
      {super.key, required this.value, required this.label, required this.icon, this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Icon(icon, size: 14, color: color ?? Colors.white70),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                  color: color ?? Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
        ]),
      );
}
