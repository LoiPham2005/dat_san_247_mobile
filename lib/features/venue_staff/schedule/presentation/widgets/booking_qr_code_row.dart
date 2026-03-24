import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class BookingQrCodeRow extends StatelessWidget {
  final String code;
  const BookingQrCodeRow({super.key, required this.code});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          const Icon(Icons.qr_code_2_rounded, size: 16, color: AppColors.textHint),
          const SizedBox(width: 10),
          const Text('Mã QR Check-in',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(code,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: Color(0xFF7C3AED),
                    letterSpacing: 2)),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
            },
            child: const Icon(Icons.copy_rounded, size: 14, color: AppColors.textHint),
          ),
        ]),
      );
}
