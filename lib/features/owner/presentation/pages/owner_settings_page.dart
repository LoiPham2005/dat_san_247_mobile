import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

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
            expandedHeight: 180,
            backgroundColor: _brand,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Text('O', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _brand)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Nguyễn Văn Chủ Sân', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: const Text('Partner (Đối tác)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Cài đặt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),

          // ── Settings List ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _MenuGroup(title: 'Tài Khoản & Bảo Mật', children: [
                  _MenuItem(icon: Icons.person_outline_rounded, title: 'Thông tin cá nhân', onTap: () => _stub(context)),
                  _MenuItem(icon: Icons.account_balance_wallet_outlined, title: 'Ví & Thanh toán', onTap: () => _stub(context)),
                  _MenuItem(icon: Icons.security_rounded, title: 'Mật khẩu & Đăng nhập', onTap: () => _stub(context)),
                ]),
                const SizedBox(height: 16),
                _MenuGroup(title: 'Ứng Dụng', children: [
                  _MenuItem(icon: Icons.notifications_none_rounded, title: 'Thông báo', onTap: () => _stub(context)),
                  _MenuItem(icon: Icons.language_rounded, title: 'Ngôn ngữ', value: 'Tiếng Việt', onTap: () => _stub(context)),
                  _MenuItem(icon: Icons.dark_mode_outlined, title: 'Giao diện tối', hasSwitch: true, switchValue: false, onTap: () {}),
                ]),
                const SizedBox(height: 16),
                _MenuGroup(title: 'Hỗ Trợ', children: [
                  _MenuItem(icon: Icons.help_outline_rounded, title: 'Trung tâm trợ giúp', onTap: () => _stub(context)),
                  _MenuItem(icon: Icons.contact_support_outlined, title: 'Liên hệ DatSan247', onTap: () => _stub(context)),
                  _MenuItem(icon: Icons.info_outline_rounded, title: 'Điều khoản & Chính sách', onTap: () => _stub(context)),
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
                      child: Text('Đăng xuất', style: TextStyle(color: AppColors.error, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(child: Text('DatSan247 For Owner v1.0.0', style: TextStyle(color: AppColors.textHint, fontSize: 12))),
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

class _MenuGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _MenuGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final bool hasSwitch;
  final bool switchValue;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, this.value, this.hasSwitch = false, this.switchValue = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF0891B2).withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: const Color(0xFF0891B2)),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
            if (value != null) Text(value!, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            if (hasSwitch)
              SizedBox(height: 24, child: Switch(value: switchValue, onChanged: (_) => onTap(), activeColor: const Color(0xFF0891B2)))
            else
              const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
