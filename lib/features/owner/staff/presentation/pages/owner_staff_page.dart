import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/models/staff_models.dart';
import 'package:dat_san_247_mobile/features/owner/staff/presentation/cubit/owner_staff_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-10: Quản Lý Nhân Viên
// DB: venue_staff (venue_id), users, venue_staff_invites
// ══════════════════════════════════════════════════════════════════════════════
class OwnerStaffPage extends StatelessWidget {
  final String venueId;
  final String venueName;
  const OwnerStaffPage({super.key, required this.venueId, required this.venueName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OwnerStaffCubit>()..fetchStaffData(venueId),
      child: BlocListener<OwnerStaffCubit, BaseState<OwnerStaffState>>(
        listenWhen: (prev, curr) => curr.isFailure,
        listener: (context, state) {
          if (state.error != null) {
            getIt<ToastService>().error(state.error!);
          }
        },
        child: _OwnerStaffView(venueId: venueId, venueName: venueName),
      ),
    );
  }
}

class _OwnerStaffView extends StatefulWidget {
  final String venueId;
  final String venueName;
  const _OwnerStaffView({required this.venueId, required this.venueName});

  @override
  State<_OwnerStaffView> createState() => _OwnerStaffViewState();
}

class _OwnerStaffViewState extends State<_OwnerStaffView> with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerStaffCubit, BaseState<OwnerStaffState>>(
      builder: (context, state) {
        final staffMembers = state.data?.staffMembers ?? [];
        final pendingInvites = state.data?.pendingInvites ?? [];

        final activeStaff = staffMembers.where((s) => s.isActive).toList();
        final inactiveStaff = staffMembers.where((s) => !s.isActive).toList();
        final filteredInvites = pendingInvites
            .where((i) => i.status == StaffInviteStatus.PENDING || i.status == StaffInviteStatus.EXPIRED)
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                pinned: true,
                expandedHeight: 140,
                backgroundColor: _brand,
                titleSpacing: 0,
                title: const Text('Nhân Viên',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context)),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.person_add_rounded, color: Colors.white),
                      tooltip: 'Mời nhân viên',
                      onPressed: () => _showInviteSheet(context))
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 46, 20, 0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(widget.venueName,
                                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Row(children: [
                                _SChip('${activeStaff.length} đang làm', AppColors.success),
                                const SizedBox(width: 8),
                                _SChip('${inactiveStaff.length} nghỉ', AppColors.textHint),
                                const SizedBox(width: 8),
                                _SChip('${filteredInvites.length} lời mời', AppColors.warning),
                              ]),
                            ]))),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabCtrl,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Đang làm (${activeStaff.length})'),
                    Tab(text: 'Đã nghỉ (${inactiveStaff.length})'),
                    Tab(text: 'Lời mời (${filteredInvites.length})'),
                  ],
                ),
              ),
            ],
            body: TabBarView(controller: _tabCtrl, children: [
              // Tab 1: Active staff
              _buildStaffList(activeStaff, 'Chưa có nhân viên đang hoạt động', (staff) {
                _confirmDeactivate(context, staff);
              }),
              // Tab 2: Inactive
              _buildStaffList(inactiveStaff, 'Không có nhân viên đã nghỉ', (staff) {
                _confirmReactivate(context, staff);
              }, isInactive: true),
              // Tab 3: Invites
              _buildInvitesList(filteredInvites),
            ]),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showInviteSheet(context),
            backgroundColor: _brand,
            icon: const Icon(Icons.person_add_rounded, color: Colors.white),
            label: const Text('Mời Nhân Viên', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildStaffList(List<OwnerStaffModel> staff, String emptyMsg, Function(OwnerStaffModel) onAction,
      {bool isInactive = false}) {
    if (staff.isEmpty) return _EmptyStaff(emptyMsg);
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
        itemCount: staff.length,
        itemBuilder: (_, i) => _StaffCard(
              staff: staff[i],
              onChangeRole: isInactive ? null : () => _showChangeRoleSheet(context, staff[i]),
              onDeactivate: isInactive ? null : () => onAction(staff[i]),
              onReactivate: isInactive ? () => onAction(staff[i]) : null,
            ));
  }

  Widget _buildInvitesList(List<StaffInviteModel> invites) {
    if (invites.isEmpty) return const _EmptyStaff('Chưa có lời mời nào');
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
        itemCount: invites.length,
        itemBuilder: (_, i) => _InviteCard(
              invite: invites[i],
              onRevoke: () => _confirmRevokeInvite(context, invites[i]),
              onForceAccept: () => context.read<OwnerStaffCubit>().forceAcceptInvite(widget.venueId, invites[i].id),
            ));
  }

  void _showInviteSheet(BuildContext context) {
    final emailCtrl = TextEditingController();
    StaffRole selectedRole = StaffRole.STAFF;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
          builder: (ctx, ss) => Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                          const SizedBox(height: 14),
                          const Row(children: [
                            Icon(Icons.person_add_rounded, color: Color(0xFF0891B2)),
                            SizedBox(width: 8),
                            Text('Mời Nhân Viên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                          ]),
                          const SizedBox(height: 16),
                          TextField(
                              controller: emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Email nhân viên *',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                          const SizedBox(height: 12),
                          const _Label('Vai trò'),
                          const SizedBox(height: 8),
                          Row(
                              children: [StaffRole.MANAGER, StaffRole.STAFF, StaffRole.RECEPTIONIST]
                                  .map((r) => GestureDetector(
                                        onTap: () => ss(() => selectedRole = r),
                                        child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 150),
                                            margin: const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            decoration: BoxDecoration(
                                                color: selectedRole == r ? const Color(0xFF0891B2) : Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: selectedRole == r
                                                        ? const Color(0xFF0891B2)
                                                        : AppColors.borderLight)),
                                            child: Column(children: [
                                              Text(r.emoji, style: const TextStyle(fontSize: 16)),
                                              const SizedBox(height: 2),
                                              Text(r.label,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: selectedRole == r
                                                          ? Colors.white
                                                          : AppColors.textSecondary)),
                                            ])),
                                      ))
                                  .toList()),
                          const SizedBox(height: 12),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.info.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                              child: Text(_roleDesc(selectedRole),
                                  style: const TextStyle(fontSize: 11, color: AppColors.info))),
                          const SizedBox(height: 16),
                          const Text('Link mời sẽ hết hạn sau 7 ngày.',
                              style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                          const SizedBox(height: 12),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  final email = emailCtrl.text.trim();
                                  if (email.isEmpty || !email.contains('@')) {
                                    getIt<ToastService>().error('Email không hợp lệ');
                                    return;
                                  }
                                  Navigator.pop(ctx);
                                  context.read<OwnerStaffCubit>().inviteStaff(widget.venueId, email, selectedRole);
                                  HapticFeedback.mediumImpact();
                                  _tabCtrl.animateTo(2);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0891B2),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 13),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child:
                                    const Text('Gửi Lời Mời', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              )),
                        ])),
              )),
    );
  }

  void _showChangeRoleSheet(BuildContext context, OwnerStaffModel staff) {
    // Tạm thời chưa implement đổi vai trò qua API backend vì cần check endpoint PATCH staffId/role
    getIt<ToastService>().info('Tính năng đổi vai trò đang được phát triển');
  }

  void _confirmDeactivate(BuildContext context, OwnerStaffModel staff) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Vô hiệu hoá nhân viên?', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text(
                  '${staff.fullName} sẽ không còn quyền truy cập staff portal của venue này. Có thể khôi phục lại sau.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<OwnerStaffCubit>().updateStaffStatus(widget.venueId, staff.id, false);
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Vô hiệu hoá', style: TextStyle(color: Colors.white))),
              ],
            ));
  }

  void _confirmReactivate(BuildContext context, OwnerStaffModel staff) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Khôi phục nhân viên?', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('${staff.fullName} sẽ được khôi phục quyền truy cập.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<OwnerStaffCubit>().updateStaffStatus(widget.venueId, staff.id, true);
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Khôi phục', style: TextStyle(color: Colors.white))),
              ],
            ));
  }

  void _confirmRevokeInvite(BuildContext context, StaffInviteModel invite) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Thu hồi lời mời?', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('Lời mời gửi đến ${invite.inviteEmail} sẽ bị vô hiệu hoá.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<OwnerStaffCubit>().revokeInvite(widget.venueId, invite.id);
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Thu hồi', style: TextStyle(color: Colors.white))),
              ],
            ));
  }

  String _roleDesc(StaffRole r) => switch (r) {
        StaffRole.MANAGER => 'Toàn quyền: quản lý booking, staff, dịch vụ, bảng giá.',
        StaffRole.STAFF => 'Vận hành hàng ngày: check-in, lịch sân, thêm addon cho booking.',
        StaffRole.RECEPTIONIST => 'Chỉ check-in và xem lịch booking hôm nay.',
        StaffRole.OWNER => 'Chủ sân — toàn quyền.',
      };
}

// ── Staff Card ────────────────────────────────────────────────────────────────
class _StaffCard extends StatelessWidget {
  final OwnerStaffModel staff;
  final VoidCallback? onChangeRole, onDeactivate, onReactivate;
  const _StaffCard({required this.staff, this.onChangeRole, this.onDeactivate, this.onReactivate});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final roleColor = switch (staff.role) {
      StaffRole.MANAGER => const Color(0xFF7C3AED),
      StaffRole.STAFF => brand,
      StaffRole.RECEPTIONIST => AppColors.success,
      StaffRole.OWNER => AppColors.warning,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: staff.isActive ? 1.0 : 0.55,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                // Avatar
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: roleColor.withOpacity(0.15), shape: BoxShape.circle),
                    child: Center(
                        child: Text(staff.fullName[0].toUpperCase(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: roleColor)))),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                        child: Text(staff.fullName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                            overflow: TextOverflow.ellipsis)),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text('${staff.role.emoji} ${staff.role.label}',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: roleColor))),
                  ]),
                  const SizedBox(height: 2),
                  if (staff.email != null)
                    Text(staff.email!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                  if (staff.phone != null)
                    Text(staff.phone!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                ])),
              ])),
          // Work schedule
          if (staff.isActive && staff.workDays.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(children: [
                  const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textHint),
                  const SizedBox(width: 6),
                  if (staff.workStartTime != null)
                    Text('${staff.workStartTime} – ${staff.workEndTime}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Wrap(
                          spacing: 3,
                          children: staff.workDays
                              .map((d) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                  child: Text(d.short,
                                      style: const TextStyle(
                                          fontSize: 9, color: Color(0xFF0891B2), fontWeight: FontWeight.bold))))
                              .toList())),
                ])),
          ],
          // Actions
          const Divider(height: 1, color: AppColors.borderLight),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
              child: Row(children: [
                if (onChangeRole != null) _Btn(Icons.swap_horiz_rounded, 'Đổi vai trò', brand, onChangeRole!),
                if (onChangeRole != null) const SizedBox(width: 8),
                if (onDeactivate != null) _Btn(Icons.person_off_rounded, 'Vô hiệu hoá', AppColors.error, onDeactivate!),
                if (onReactivate != null) _Btn(Icons.person_add_rounded, 'Khôi phục', AppColors.success, onReactivate!),
              ])),
        ]),
      ),
    );
  }
}

// ── Invite Card ───────────────────────────────────────────────────────────────
class _InviteCard extends StatelessWidget {
  final StaffInviteModel invite;
  final VoidCallback onRevoke;
  final VoidCallback onForceAccept;
  const _InviteCard({required this.invite, required this.onRevoke, required this.onForceAccept});
  @override
  Widget build(BuildContext context) {
    final statusColor = switch (invite.status) {
      StaffInviteStatus.PENDING => AppColors.warning,
      StaffInviteStatus.ACCEPTED => AppColors.success,
      StaffInviteStatus.REJECTED => AppColors.error,
      StaffInviteStatus.EXPIRED => AppColors.textHint,
      StaffInviteStatus.REVOKED => AppColors.textHint,
    };
    final roleColor = switch (invite.role) {
      StaffRole.MANAGER => const Color(0xFF7C3AED),
      StaffRole.STAFF => const Color(0xFF0891B2),
      StaffRole.RECEPTIONIST => AppColors.success,
      StaffRole.OWNER => AppColors.warning,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Row(children: [
        Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Icon(Icons.email_rounded, color: statusColor, size: 20))),
        const SizedBox(width: 10),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(invite.inviteEmail,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          Row(children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('${invite.role.emoji} ${invite.role.label}',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: roleColor))),
            const SizedBox(width: 6),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(invite.status.label,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor))),
          ]),
        ])),
        if (invite.status == StaffInviteStatus.PENDING) ...[
          _SmallBtn('Duyệt ngay', AppColors.success, onForceAccept),
          const SizedBox(width: 4),
          _SmallBtn('Thu hồi', AppColors.error, onRevoke),
        ],
      ]),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SmallBtn(this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color))));
}

class _EmptyStaff extends StatelessWidget {
  final String msg;
  const _EmptyStaff(this.msg);
  @override
  Widget build(BuildContext context) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.people_outline_rounded, size: 48, color: AppColors.textHint),
        const SizedBox(height: 12),
        Text(msg, style: const TextStyle(color: AppColors.textHint))
      ]));
}

class _SChip extends StatelessWidget {
  final String label;
  final Color color;
  const _SChip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)));
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Btn(this.icon, this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))
          ])));
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)));
}
