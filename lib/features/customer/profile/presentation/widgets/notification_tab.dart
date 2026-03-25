import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'setting_card.dart';
import 'switch_row.dart';

class NotificationTab extends StatelessWidget {
  final bool notifPush;
  final bool notifEmail;
  final bool notifSms;
  final bool notifBooking;
  final bool notifPromotion;
  final bool notifPayment;
  final bool notifSystem;
  final Function(bool) onPushChanged;
  final Function(bool) onEmailChanged;
  final Function(bool) onSmsChanged;
  final Function(bool) onBookingChanged;
  final Function(bool) onPromotionChanged;
  final Function(bool) onPaymentChanged;
  final Function(bool) onSystemChanged;
  final VoidCallback onSave;

  const NotificationTab({
    super.key,
    required this.notifPush,
    required this.notifEmail,
    required this.notifSms,
    required this.notifBooking,
    required this.notifPromotion,
    required this.notifPayment,
    required this.notifSystem,
    required this.onPushChanged,
    required this.onEmailChanged,
    required this.onSmsChanged,
    required this.onBookingChanged,
    required this.onPromotionChanged,
    required this.onPaymentChanged,
    required this.onSystemChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SettingCard(
            title: 'Kênh thông báo',
            children: [
              SwitchRow(
                label: 'Push Notification',
                subtitle: 'Thông báo đẩy trực tiếp',
                value: notifPush,
                icon: Icons.notifications_active_rounded,
                onChanged: onPushChanged,
              ),
              SwitchRow(
                label: 'Email',
                subtitle: 'Gửi vào hộp thư email',
                value: notifEmail,
                icon: Icons.email_rounded,
                onChanged: onEmailChanged,
              ),
              SwitchRow(
                label: 'SMS',
                subtitle: 'Tin nhắn điện thoại',
                value: notifSms,
                icon: Icons.sms_rounded,
                onChanged: onSmsChanged,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SettingCard(
            title: 'Loại thông báo',
            children: [
              SwitchRow(
                label: 'Đặt sân & Booking',
                subtitle: 'Xác nhận, nhắc lịch, check-in',
                value: notifBooking,
                icon: Icons.sports_soccer_rounded,
                onChanged: onBookingChanged,
              ),
              SwitchRow(
                label: 'Khuyến mãi',
                subtitle: 'Voucher, ưu đãi mới',
                value: notifPromotion,
                icon: Icons.local_offer_rounded,
                onChanged: onPromotionChanged,
              ),
              SwitchRow(
                label: 'Thanh toán',
                subtitle: 'Biến động số dư ví',
                value: notifPayment,
                icon: Icons.account_balance_wallet_rounded,
                onChanged: onPaymentChanged,
              ),
              SwitchRow(
                label: 'Hệ thống',
                subtitle: 'Cập nhật ứng dụng, chính sách',
                value: notifSystem,
                icon: Icons.info_outline_rounded,
                onChanged: onSystemChanged,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Lưu cài đặt',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
