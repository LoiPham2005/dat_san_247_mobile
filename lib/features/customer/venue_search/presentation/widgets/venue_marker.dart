import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';

class VenueMarker extends StatelessWidget {
  final VenueSearchResultModel venue;
  final bool isSelected;
  final NumberFormat priceFmt;

  const VenueMarker({
    super.key,
    required this.venue,
    required this.isSelected,
    required this.priceFmt,
  });

  @override
  Widget build(BuildContext context) {
    final color = (venue.isOpen ?? true) ? AppColors.primaryLightBrand : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bubble
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding:
              EdgeInsets.symmetric(horizontal: isSelected ? 10 : 8, vertical: isSelected ? 6 : 5),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(isSelected ? 12 : 10),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? color.withValues(alpha: 0.45)
                    : Colors.black.withValues(alpha: 0.22),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: isSelected ? color : const Color(0xFFE0E8F0), width: 2),
          ),
          child: isSelected
              ? Text(
                  '${priceFmt.format(venue.minPricePerHour ?? 0)}đ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : Icon(Icons.stadium_rounded, color: color, size: 18),
        ),
        // Pin tail
        CustomPaint(
          size: const Size(12, 6),
          painter: _PinTailPainter(
              color: isSelected ? color : Colors.white,
              borderColor: isSelected ? color : const Color(0xFFE0E8F0)),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  const _PinTailPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => old.color != color || old.borderColor != borderColor;
}
