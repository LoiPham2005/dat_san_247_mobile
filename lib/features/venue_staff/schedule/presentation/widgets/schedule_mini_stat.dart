import 'package:flutter/material.dart';

class ScheduleMiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;
  const ScheduleMiniStat({super.key, required this.value, required this.label, this.color});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value,
            style: TextStyle(
                color: color ?? Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ]);
}
