import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

class BookingPaymentInfoCard extends StatelessWidget {
  final PaymentDetailModel payment;

  const BookingPaymentInfoCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final methodLabel = _paymentLabel(payment.paymentMethod);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.payment_rounded, 'Thông tin thanh toán'),
          const SizedBox(height: 12),
          _infoRow(Icons.credit_card_rounded, 'Phương thức', methodLabel),
          const SizedBox(height: 8),
          _infoRow(
              Icons.attach_money_rounded, 'Số tiền', fmt.format(payment.amount)),
          if (payment.paidAt != null) ...[
            const SizedBox(height: 8),
            _infoRow(Icons.schedule_rounded, 'Thanh toán lúc',
                DateFormat('HH:mm dd/MM/yyyy').format(payment.paidAt!)),
          ],
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

  Widget _sectionHeader(IconData icon, String label) => Row(
    children: [
      Icon(icon, color: AppColors.primaryLightBrand, size: 18),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary)),
    ],
  );

  Widget _infoRow(IconData icon, String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 14, color: AppColors.textHint),
      const SizedBox(width: 6),
      SizedBox(
          width: 60,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textHint))),
      Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600))),
    ],
  );

  String _paymentLabel(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.MOMO:
        return 'MoMo 💜';
      case PaymentMethod.VNPAY:
        return 'VNPay 🔵';
      case PaymentMethod.ZALOPAY:
        return 'ZaloPay 🟢';
      case PaymentMethod.WALLET:
        return 'Ví tài khoản 👛';
      case PaymentMethod.CASH:
        return 'Tiền mặt 💵';
      case PaymentMethod.BANK_TRANSFER:
        return 'Chuyển khoản 🏦';
    }
  }
}
