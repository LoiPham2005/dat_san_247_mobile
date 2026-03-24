import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class VenueEmptyState extends StatelessWidget {
  final String message;
  const VenueEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.stadium_outlined, size: 48, color: AppColors.textHint),
        const SizedBox(height: 12),
        Text(message, style: const TextStyle(color: AppColors.textHint)),
      ]));
}
