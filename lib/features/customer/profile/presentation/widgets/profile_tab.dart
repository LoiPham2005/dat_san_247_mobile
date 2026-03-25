import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';
import 'setting_card.dart';
import 'edit_row.dart';
import 'verified_chip.dart';
import 'referral_row.dart';
import 'kyc_row.dart';

class ProfileTab extends StatelessWidget {
  final UserModel user;
  final Function(String label, String value, {bool multiline}) onEditField;
  final VoidCallback onPickGender;
  final VoidCallback onGoKyc;
  final VoidCallback onLogout;

  const ProfileTab({
    super.key,
    required this.user,
    required this.onEditField,
    required this.onPickGender,
    required this.onGoKyc,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final p = user.profile;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Basic info ──
          SettingCard(
            title: 'Thông tin cơ bản',
            children: [
              EditRow(
                label: 'Họ và tên',
                value: user.fullName,
                onEdit: () => onEditField('Họ và tên', user.fullName),
              ),
              EditRow(
                label: 'Email',
                value: user.email,
                trailing: user.isEmailVerified ? const VerifiedChip() : null,
                onEdit: null,
              ),
              EditRow(
                label: 'Số điện thoại',
                value: user.phone ?? 'Chưa cập nhật',
                onEdit: () => onEditField('Số điện thoại', user.phone ?? ''),
              ),
              EditRow(
                label: 'Giới tính',
                value: user.gender?.label ?? 'Chưa chọn',
                onEdit: onPickGender,
              ),
              EditRow(
                label: 'Ngày sinh',
                value: user.dateOfBirth != null
                    ? DateFormat('dd/MM/yyyy').format(user.dateOfBirth!)
                    : 'Chưa cập nhật',
                onEdit: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Profile info ──
          SettingCard(
            title: 'Hồ sơ công khai',
            children: [
              EditRow(
                label: 'Tiểu sử',
                value: p?.bio ?? 'Chưa cập nhật',
                onEdit: () => onEditField('Tiểu sử', p?.bio ?? '', multiline: true),
                multiline: true,
              ),
              EditRow(label: 'Thành phố', value: p?.city ?? 'Chưa chọn', onEdit: () {}),
              EditRow(label: 'Quận/Huyện', value: p?.district ?? 'Chưa chọn', onEdit: () {}),
            ],
          ),
          const SizedBox(height: 14),

          // ── Referral code ──
          if (p?.referralCode != null)
            SettingCard(
              title: 'Mời bạn bè',
              children: [ReferralRow(code: p!.referralCode!)],
            ),
          const SizedBox(height: 14),

          // ── KYC ──
          SettingCard(
            title: 'Xác minh danh tính (KYC)',
            children: [KycRow(status: user.kycStatus, onTap: onGoKyc)],
          ),
          const SizedBox(height: 14),

          // ── Bank accounts ──
          SettingCard(
            title: 'Tài khoản ngân hàng',
            children: [
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.primaryLightBrand,
                  size: 20,
                ),
                title: const Text('Quản lý tài khoản rút tiền', style: TextStyle(fontSize: 14)),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('→ Trang quản lý tài khoản ngân hàng')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Logout / Security ──
          SettingCard(
            title: 'Bảo mật',
            children: [
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                title: const Text('Đổi mật khẩu', style: TextStyle(fontSize: 14)),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.devices_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                title: const Text('Thiết bị đã đăng nhập', style: TextStyle(fontSize: 14)),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Logout ──
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: const Text(
                'Đăng xuất',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
