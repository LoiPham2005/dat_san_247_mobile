import 'package:flutter/material.dart';

class VoucherWidget extends StatelessWidget {
  final String? voucherCode;
  final VoidCallback onTap;

  const VoucherWidget({
    super.key,
    this.voucherCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.card_giftcard, color: Colors.orange[600], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              voucherCode != null && voucherCode!.isNotEmpty
                  ? 'Voucher: $voucherCode'
                  : 'Chọn hoặc nhập mã voucher',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.orange[700],
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              voucherCode != null && voucherCode!.isNotEmpty ? 'Đổi mã' : 'Chọn',
              style: TextStyle(color: Colors.orange[700]),
            ),
          ),
        ],
      ),
    );
  }
}