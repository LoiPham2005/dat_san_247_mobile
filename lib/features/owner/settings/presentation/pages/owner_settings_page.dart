import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/settings/presentation/widgets/settings_menu_group.dart';
import 'package:dat_san_247_mobile/features/owner/settings/presentation/widgets/settings_menu_item.dart';
import 'package:dat_san_247_mobile/features/owner/settings/presentation/widgets/settings_profile_header.dart';

class OwnerSettingsPage extends StatelessWidget {
  const OwnerSettingsPage({super.key});

  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: _brand,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_brandDark, _brand],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(height: 38),
                      Text('Quản lý thông tin 👤',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Hồ sơ & Cài đặt ⚙️',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      SettingsProfileHeader(
                        name: 'Nguyễn Văn Chủ Sân',
                        type: 'Partner (Đối tác)',
                        avatarLetter: 'O',
                        brand: _brand,
                      ),
                    ]),
                  ),
                ),
              ),
              title: const Text('Cài đặt',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
            ),
          ),

          // ── Settings List ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SettingsMenuGroup(title: 'Tài Khoản & Bảo Mật', children: [
                  SettingsMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Thông tin cá nhân',
                      onTap: () => _stub(context)),
                  SettingsMenuItem(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Ví & Thanh toán',
                      onTap: () => _stub(context)),
                  SettingsMenuItem(
                      icon: Icons.security_rounded,
                      title: 'Mật khẩu & Đăng nhập',
                      onTap: () => _stub(context)),
                ]),
                const SizedBox(height: 16),
                SettingsMenuGroup(title: 'Ứng Dụng', children: [
                  SettingsMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Thông báo',
                      onTap: () => _stub(context)),
                  SettingsMenuItem(
                      icon: Icons.language_rounded,
                      title: 'Ngôn ngữ',
                      value: 'Tiếng Việt',
                      onTap: () => _stub(context)),
                  SettingsMenuItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Giao diện tối',
                      hasSwitch: true,
                      switchValue: false,
                      onTap: () {}),
                ]),
                const SizedBox(height: 16),
                SettingsMenuGroup(title: 'Hỗ Trợ', children: [
                  SettingsMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Trung tâm trợ giúp',
                      onTap: () => _stub(context)),
                  SettingsMenuItem(
                      icon: Icons.contact_support_outlined,
                      title: 'Liên hệ DatSan247',
                      onTap: () => _stub(context)),
                  SettingsMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'Điều khoản & Chính sách',
                      onTap: () => _stub(context)),
                ]),
                const SizedBox(height: 24),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    context.go('/auth/login');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: const Center(
                      child: Text('Đăng xuất',
                          style: TextStyle(color: AppColors.error, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                    child: Text('DatSan247 For Owner v1.0.0',
                        style: TextStyle(color: AppColors.textHint, fontSize: 12))),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _stub(BuildContext context) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tính năng sắp ra mắt!')));
  }
}
