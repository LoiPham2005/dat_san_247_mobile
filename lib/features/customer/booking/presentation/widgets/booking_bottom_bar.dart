import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingBottomBar extends StatelessWidget {
  final bool canBook;
  final double totalPrice;
  final VoidCallback onConfirm;
  final ColorScheme colorScheme;

  const BookingBottomBar({
    super.key,
    required this.canBook,
    required this.totalPrice,
    required this.onConfirm,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Price summary
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng thanh toán',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${NumberFormat('#,##0').format(totalPrice)}đ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Booking button
              Expanded(
                flex: 2,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: canBook ? LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.8),
                      ],
                    ) : null,
                    color: canBook ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: canBook ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ] : null,
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: Icon(
                      canBook ? Icons.check_circle : Icons.warning,
                      color: canBook ? Colors.white : Colors.grey[600],
                      size: 24,
                    ),
                    label: Text(
                      canBook ? "XÁC NHẬN ĐẶT SÂN" : "CHƯA ĐỦ THÔNG TIN",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: canBook ? Colors.white : Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    onPressed: canBook ? onConfirm : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}