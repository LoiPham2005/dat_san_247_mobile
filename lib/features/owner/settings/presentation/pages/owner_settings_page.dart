import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/settings/presentation/widgets/settings_menu_group.dart';
import 'package:dat_san_247_mobile/features/owner/settings/presentation/widgets/settings_menu_item.dart';
import 'package:dat_san_247_mobile/features/owner/settings/presentation/widgets/settings_profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OwnerSettingsPage extends StatelessWidget {
  const OwnerSettingsPage({super.key});

  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: CustomScrollView(
            slivers: [
              // ── AppBar ──
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                backgroundColor: _brand,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: const Text('Cài đặt hệ thống',
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
                        _showLogoutDialog(context);
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
                              style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
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
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn sẽ cần đăng nhập lại để tiếp tục quản lý hệ thống.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _stub(BuildContext context) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Tính năng sắp ra mắt!')));
  }
}
