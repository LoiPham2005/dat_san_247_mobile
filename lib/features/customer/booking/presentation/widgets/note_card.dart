import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class NoteCard extends StatelessWidget {
  final TextEditingController controller;

  const NoteCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.note_alt_rounded, 'Ghi chú cho sân'),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            maxLength: 200,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'VD: Mang theo giày cỏ, đặt số lượng 6 người...',
              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
              filled: true,
              fillColor: AppColors.mutedLight,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
          color: AppColors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2))
    ],
  );

  Widget _sectionTitle(IconData icon, String title) => Row(
    children: [
      Icon(icon, color: AppColors.primaryLightBrand, size: 20),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary)),
    ],
  );
}
