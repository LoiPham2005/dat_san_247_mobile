import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:flutter/material.dart';

class VenueActionButtons extends StatelessWidget {
  final VoidCallback onCallPressed;
  final VoidCallback onDirectionsPressed;
  final ColorScheme colorScheme;

  const VenueActionButtons({
    super.key,
    required this.onCallPressed,
    required this.onDirectionsPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 5,
                shadowColor: colorScheme.primary.withOpacity(0.3),
              ),
              icon: const Icon(Icons.phone),
              label: const Text(
                "Gọi ngay",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: onCallPressed,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: onDirectionsPressed,
              child: const Icon(Icons.directions),
            ),
          ),
        ],
      ),
    );
  }
}
