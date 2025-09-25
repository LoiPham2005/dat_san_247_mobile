import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceSummaryCard extends StatelessWidget {
  final double pricePerHour;
  final int duration;
  final double totalPrice;

  const PriceSummaryCard({
    super.key,
    required this.pricePerHour,
    required this.duration,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Tóm tắt giá",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildPriceRow(
                  'Giá thuê sân',
                  '${NumberFormat('#,##0').format(pricePerHour)}đ/giờ',
                  isSubtotal: true,
                  context: context,
                ),
                5.height,
                _buildPriceRow(
                  'Thời gian thuê',
                  '$duration giờ',
                  isSubtotal: true,
                  context: context,
                ),
                const Divider(height: 20, color: Colors.black),
                _buildPriceRow(
                  'Tạm tính',
                  '${NumberFormat('#,##0').format(pricePerHour * duration)}đ',
                  isSubtotal: true,
                  context: context,
                ),
                5.height,
                _buildPriceRow(
                  'Phí dịch vụ',
                  'Miễn phí',
                  isSubtotal: true,
                  color: Colors.green[600],
                  context: context,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildPriceRow(
                    'TỔNG CỘNG',
                    '${NumberFormat('#,##0').format(totalPrice)}đ',
                    isTotal: true,
                    context: context,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Discount info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.local_offer, color: Colors.orange[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ưu đãi đặt sân',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      Text(
                        'Đặt từ 3 giờ trở lên được giảm 5%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isSubtotal = false,
    bool isTotal = false,
    Color? color,
    BuildContext? context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color:
                color ??
                (isTotal ? Theme.of(context!).primaryColor : Colors.grey[700]),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color:
                color ??
                (isTotal ? Theme.of(context!).primaryColor : Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
