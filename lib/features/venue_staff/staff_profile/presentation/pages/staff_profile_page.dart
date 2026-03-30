import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/widgets/profile_info_row.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/widgets/profile_menu_row.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/widgets/profile_role_pill.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/widgets/profile_today_stat.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/pages/staff_system_notifications_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/data/models/pricing_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/presentation/pages/pricing_rules_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/presentation/pages/venue_services_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/pages/staff_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/widgets/profile_section.dart';

@route
class StaffProfilePage extends StatefulWidget {
  final bool isManager;
  const StaffProfilePage({super.key, this.isManager = false});

  @override
  State<StaffProfilePage> createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends State<StaffProfilePage> {
  static const Color _brand = Color(0xFF7C3AED);
  static const Color _brandDark = Color(0xFF4C1D95);

  // Mock profile data — từ venue_staff JOIN users JOIN venues
  late final StaffProfileModel _profile = StaffProfileModel(
    userId: 'u2',
    fullName: 'Trần Thị Nhân Viên',
    email: 'nhanvien@example.com',
    phone: '0987654321',
    avatarUrl: null,
    venueStaffId: 'vs2',
    venueId: 'v1',
    role: widget.isManager ? VenueStaffRole.MANAGER : VenueStaffRole.STAFF,
    isActive: true,
    joinedAt: DateTime(2026, 1, 1),
    workStartTime: '14:00',
    workEndTime: '22:00',
    workDays: ['MONDAY', 'WEDNESDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'],
    note: 'Ca chiều – tối. Phụ trách sân A và B.',
    venueName: 'Sân K34 Phạm Văn Đồng',
    venueAddress: '34 Phạm Văn Đồng, Bắc Từ Liêm, Hà Nội',
    venuePhone: '024 3856 9900',
  );

  // Today stats (sẽ lấy từ API sau)
  final int _todayCheckIns = 4;
  final int _todayAddons = 3;

  @override
  Widget build(BuildContext context) {
    final role = _profile.role;

    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: CustomScrollView(
            slivers: [
              // ── AppBar / Hero ──
              SliverAppBar(
                pinned: true,
                expandedHeight: 210,
                backgroundColor: _brand,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: const Text('Hồ sơ nhân viên',
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const StaffSystemNotificationsPage())),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [_brandDark, _brand],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                        child: Column(children: [
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // ── Avatar ──
                            Stack(children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white.withOpacity(0.5), width: 2.5),
                                ),
                                child: Center(
                                  child: Text(_profile.fullName[0],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                                  child:
                                      const Icon(Icons.check_rounded, size: 11, color: Colors.white),
                                ),
                              ),
                            ]),
                            const SizedBox(width: 14),
                            Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(_profile.fullName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              if (_profile.phone != null)
                                Row(children: [
                                  const Icon(Icons.phone_rounded, size: 12, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text(_profile.phone!,
                                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                ]),
                              const SizedBox(height: 8),
                              ProfileRolePill(role: role),
                            ])),
                          ]),
                          const SizedBox(height: 14),
                          // ── Venue info ──
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(children: [
                              const Icon(Icons.stadium_rounded, color: Colors.white70, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(_profile.venueName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                if (_profile.venueAddress != null)
                                  Text(_profile.venueAddress!,
                                      style: const TextStyle(color: Colors.white60, fontSize: 10),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                              ])),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(children: [
                    // ── Today stats ──
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
                          ]),
                      child: Row(children: [
                        ProfileTodayStat(
                            label: 'Check-in hôm nay',
                            value: '$_todayCheckIns',
                            icon: Icons.how_to_reg_rounded,
                            color: AppColors.success),
                        _VertDivider(),
                        ProfileTodayStat(
                            label: 'Addon đã thêm',
                            value: '$_todayAddons',
                            icon: Icons.add_shopping_cart_rounded,
                            color: _brand),
                        _VertDivider(),
                        ProfileTodayStat(
                            label: 'Ngày làm',
                            value: '${_profile.workDays.length}/tuần',
                            icon: Icons.calendar_view_week_rounded,
                            color: AppColors.info),
                      ]),
                    ),
                    const SizedBox(height: 12),

                    // ── Ca làm việc ──
                    ProfileSection(
                        title: 'Ca Làm Việc',
                        icon: Icons.work_history_rounded,
                        color: _brand,
                        children: [
                          ProfileInfoRow(
                              label: 'Ca hôm nay',
                              value: _profile.shiftLabel,
                              valueColor: _brand,
                              isBold: true),
                          ProfileInfoRow(
                              label: 'Ngày làm trong tuần',
                              value: _profile.workDaysLabel.isEmpty
                                  ? 'Chưa cài'
                                  : _profile.workDaysLabel),
                          ProfileInfoRow(
                              label: 'Ngày tham gia',
                              value: _profile.joinedAt != null
                                  ? DateFormat('dd/MM/yyyy').format(_profile.joinedAt!)
                                  : '—'),
                          if (_profile.note != null && _profile.note!.isNotEmpty)
                            ProfileInfoRow(label: 'Ghi chú', value: _profile.note!),
                        ]),
                    const SizedBox(height: 12),

                    // ── Quyền hạn ──
                    ProfileSection(
                        title: 'Quyền Hạn — ${role.label}',
                        icon: Icons.verified_user_rounded,
                        color: const Color(0xFF0891B2),
                        children: [
                          ..._permissions(role),
                        ]),
                    const SizedBox(height: 12),

                    // ── Manager-only tools ──
                    if (widget.isManager) ...[
                      ProfileSection(
                          title: 'Công Cụ Quản Lý',
                          icon: Icons.admin_panel_settings_rounded,
                          color: AppColors.warning,
                          children: [
                            ProfileMenuRow(
                                icon: Icons.price_change_rounded,
                                label: 'Bảng giá',
                                color: AppColors.warning,
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const PricingRulesPage()))),
                            ProfileMenuRow(
                                icon: Icons.storefront_rounded,
                                label: 'Dịch vụ bán kèm',
                                color: AppColors.success,
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const VenueServicesPage()))),
                            ProfileMenuRow(
                                icon: Icons.people_rounded,
                                label: 'Quản lý nhân viên',
                                color: _brand,
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const StaffManagementPage()))),
                          ]),
                      const SizedBox(height: 12),
                    ],

                    // ── Menu ──
                    ProfileSection(
                        title: 'Cài Đặt & Hỗ Trợ',
                        icon: Icons.settings_rounded,
                        color: AppColors.textHint,
                        children: [
                          ProfileMenuRow(
                              icon: Icons.notifications_rounded,
                              label: 'Trung tâm thông báo',
                              color: _brand,
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const StaffSystemNotificationsPage()))),
                          ProfileMenuRow(
                              icon: Icons.help_center_rounded,
                              label: 'Hỗ trợ',
                              color: AppColors.info,
                              onTap: () {}),
                          ProfileMenuRow(
                              icon: Icons.info_outline_rounded,
                              label: 'Về ứng dụng',
                              color: AppColors.textHint,
                              onTap: () {}),
                          ProfileMenuRow(
                              icon: Icons.logout_rounded,
                              label: 'Đăng xuất',
                              color: AppColors.error,
                              isDestructive: true,
                              onTap: () => _logout(context)),
                        ]),

                    const SizedBox(height: 30),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _permissions(VenueStaffRole role) {
    final all = [
      ('Quét QR check-in', true, AppColors.success),
      ('Xem lịch hôm nay', true, AppColors.success),
      ('Xem booking', true, AppColors.success),
      (
        'Thêm addon vào booking',
        role == VenueStaffRole.MANAGER || role == VenueStaffRole.STAFF,
        AppColors.success
      ),
      ('Xác nhận / huỷ booking', role == VenueStaffRole.MANAGER, AppColors.success),
      ('Bảng giá & dịch vụ', role == VenueStaffRole.MANAGER, AppColors.success),
      ('Xem doanh thu', role == VenueStaffRole.MANAGER, AppColors.success),
      ('Quản lý nhân viên', role == VenueStaffRole.MANAGER, AppColors.success),
      ('Tạo bảo trì khẩn cấp', role == VenueStaffRole.MANAGER, AppColors.success),
    ];
    return all
        .map((p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Icon(p.$2 ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 14, color: p.$2 ? p.$3 : AppColors.borderLight),
                const SizedBox(width: 10),
                Text(p.$1,
                    style: TextStyle(
                        fontSize: 12, color: p.$2 ? AppColors.textPrimary : AppColors.textHint)),
              ]),
            ))
        .toList();
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn sẽ thoát khỏi Staff Portal. Phiên làm việc sẽ kết thúc.'),
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
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: AppColors.borderLight);
}
