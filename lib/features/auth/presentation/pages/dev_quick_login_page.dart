import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

// ──────────────────────────────────────────────────────────────────────────
// Dev Quick Login — Chỉ dùng trong Development
// Click vào role → navigate thẳng đến shell tương ứng
// ──────────────────────────────────────────────────────────────────────────
class DevQuickLoginPage extends StatelessWidget {
  const DevQuickLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ── Header ──
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.developer_mode_rounded, color: Color(0xFF94A3B8), size: 22),
                ),
                const SizedBox(width: 12),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🛠 Dev Mode', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('Chọn vai trò để vào nhanh', style: TextStyle(color: Color(0xFFF1F5F9), fontSize: 16, fontWeight: FontWeight.bold)),
                ]),
              ]),
              const SizedBox(height: 32),

              // ── Role Cards ──
              _DevRoleCard(
                role: 'Customer',
                subtitle: 'Khách hàng — đặt sân, xem lịch, thanh toán',
                icon: Icons.person_rounded,
                color: AppColors.primaryLightBrand,
                gradient: [const Color(0xFF0F7A35), const Color(0xFF22C55E)],
                badge: 'customer@test.com',
                features: ['Tìm & đặt sân', 'My Bookings', 'Ví điện tử', 'Hỗ trợ'],
                onTap: () => context.go('/main'),
              ),
              const SizedBox(height: 14),

              _DevRoleCard(
                role: 'Owner',
                subtitle: 'Chủ sân — quản lý venue, booking, doanh thu',
                icon: Icons.stadium_rounded,
                color: const Color(0xFF1565C0),
                gradient: [const Color(0xFF0D47A1), const Color(0xFF1E88E5)],
                badge: 'owner@test.com',
                features: ['Dashboard', 'Xác nhận booking', 'Quản lý sân', 'Doanh thu'],
                onTap: () => context.go('/owner'),
              ),
              const SizedBox(height: 14),

              _DevRoleCard(
                role: 'Venue Staff',
                subtitle: 'Nhân viên sân — check-in, xem lịch hôm nay',
                icon: Icons.badge_rounded,
                color: const Color(0xFF7C3AED),
                gradient: [const Color(0xFF4C1D95), const Color(0xFF7C3AED)],
                badge: 'staff@test.com',
                features: ['Check-in QR', 'Lịch hôm nay', 'Addon dịch vụ'],
                onTap: () => context.go('/venue-staff'),
              ),

              const SizedBox(height: 48),

              // ── Real Login link ──
              Center(
                child: GestureDetector(
                  onTap: () => context.push('/login'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF334155)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.login_rounded, size: 16, color: Color(0xFF94A3B8)),
                      SizedBox(width: 8),
                      Text('Đăng nhập thật', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _DevRoleCard extends StatefulWidget {
  final String role;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final String badge;
  final List<String> features;
  final VoidCallback onTap;

  const _DevRoleCard({
    required this.role,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.badge,
    required this.features,
    required this.onTap,
  });

  @override
  State<_DevRoleCard> createState() => _DevRoleCardState();
}

class _DevRoleCardState extends State<_DevRoleCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { HapticFeedback.selectionClick(); _ctrl.forward(); },
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: widget.color.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Icon(widget.icon, color: AppColors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.role, style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                  Text(widget.subtitle, style: const TextStyle(color: AppColors.white70, fontSize: 12)),
                ])),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.white.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_rounded, color: AppColors.white, size: 18),
                ),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.email_outlined, size: 12, color: AppColors.white70),
                  const SizedBox(width: 6),
                  Text(widget.badge, style: const TextStyle(color: AppColors.white70, fontSize: 11, fontFamily: 'monospace')),
                ]),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6, runSpacing: 4,
                children: widget.features.map((f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                  child: Text(f, style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
