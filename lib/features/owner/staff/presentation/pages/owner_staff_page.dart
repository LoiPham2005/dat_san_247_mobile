import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/models/staff_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-10: Quản Lý Nhân Viên
// DB: venue_staff (venue_id), users, venue_staff_invites
// ══════════════════════════════════════════════════════════════════════════════
class OwnerStaffPage extends StatefulWidget {
  final String venueId;
  final String venueName;
  const OwnerStaffPage({super.key, required this.venueId, required this.venueName});
  @override
  State<OwnerStaffPage> createState() => _OwnerStaffPageState();
}

class _OwnerStaffPageState extends State<OwnerStaffPage> with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);
  late TabController _tabCtrl;

  List<OwnerStaffModel> _staff = _buildMockStaff();
  List<StaffInviteModel> _invites = _buildMockInvites();

  static List<OwnerStaffModel> _buildMockStaff() {
    final now = DateTime.now();
    return [
      OwnerStaffModel(id:'vs1', venueId:'v1', userId:'u10', fullName:'Nguyễn Thị Hoa', email:'hoa@example.com', phone:'0912111222', role:StaffRole.MANAGER, isActive:true, joinedAt:now.subtract(const Duration(days:90)), workStartTime:'07:00', workEndTime:'15:00', workDays:[OwnerDayOfWeek.MONDAY, OwnerDayOfWeek.TUESDAY, OwnerDayOfWeek.WEDNESDAY, OwnerDayOfWeek.THURSDAY, OwnerDayOfWeek.FRIDAY], createdAt:now.subtract(const Duration(days:90))),
      OwnerStaffModel(id:'vs2', venueId:'v1', userId:'u11', fullName:'Trần Văn Bình', email:'binh@example.com', phone:'0933444555', role:StaffRole.STAFF, isActive:true, joinedAt:now.subtract(const Duration(days:45)), workStartTime:'15:00', workEndTime:'23:00', workDays:[OwnerDayOfWeek.MONDAY, OwnerDayOfWeek.TUESDAY, OwnerDayOfWeek.WEDNESDAY, OwnerDayOfWeek.THURSDAY, OwnerDayOfWeek.FRIDAY, OwnerDayOfWeek.SATURDAY, OwnerDayOfWeek.SUNDAY], createdAt:now.subtract(const Duration(days:45))),
      OwnerStaffModel(id:'vs3', venueId:'v1', userId:'u12', fullName:'Lê Thị Cúc', email:'cuc@example.com', phone:'0966777888', role:StaffRole.RECEPTIONIST, isActive:true, joinedAt:now.subtract(const Duration(days:20)), workDays:[OwnerDayOfWeek.SATURDAY, OwnerDayOfWeek.SUNDAY], createdAt:now.subtract(const Duration(days:20))),
      OwnerStaffModel(id:'vs4', venueId:'v1', userId:'u13', fullName:'Phạm Quốc Dũng', email:'dung@example.com', role:StaffRole.STAFF, isActive:false, deactivatedAt:DateTime.now().subtract(const Duration(days:10)), createdAt:DateTime.now().subtract(const Duration(days:60))),
    ];
  }

  static List<StaffInviteModel> _buildMockInvites() {
    final now = DateTime.now();
    return [
      StaffInviteModel(id:'inv1', venueId:'v1', inviteEmail:'newstaff@example.com', role:StaffRole.STAFF, status:StaffInviteStatus.PENDING, expiresAt:now.add(const Duration(days:3)), createdAt:now.subtract(const Duration(hours:2))),
      StaffInviteModel(id:'inv2', venueId:'v1', inviteEmail:'manager2@example.com', role:StaffRole.MANAGER, status:StaffInviteStatus.EXPIRED, expiresAt:now.subtract(const Duration(days:1)), createdAt:now.subtract(const Duration(days:8))),
    ];
  }

  List<OwnerStaffModel> get _activeStaff => _staff.where((s) => s.isActive).toList();
  List<OwnerStaffModel> get _inactiveStaff => _staff.where((s) => !s.isActive).toList();

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true, expandedHeight: 155, backgroundColor: _brand,
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
            actions: [IconButton(icon: const Icon(Icons.person_add_rounded, color: Colors.white), tooltip: 'Mời nhân viên', onPressed: () => _showInviteSheet(context))],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 46, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.venueName, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                  const Text('Nhân Viên', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Row(children: [
                    _SChip('${_activeStaff.length} đang làm', AppColors.success),
                    const SizedBox(width: 8),
                    _SChip('${_inactiveStaff.length} nghỉ', AppColors.textHint),
                    const SizedBox(width: 8),
                    _SChip('${_invites.where((i) => i.status == StaffInviteStatus.PENDING).length} mời đang chờ', AppColors.warning),
                  ]),
                ]))),
              ),
              title: const Text('Nhân Viên', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            bottom: TabBar(
              controller: _tabCtrl,
              indicatorColor: Colors.white, indicatorWeight: 3,
              labelColor: Colors.white, unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Đang làm (${_activeStaff.length})'),
                Tab(text: 'Đã nghỉ (${_inactiveStaff.length})'),
                Tab(text: 'Lời mời (${_invites.length})'),
              ],
            ),
          ),
        ],
        body: TabBarView(controller: _tabCtrl, children: [
          // Tab 1: Active staff
          _activeStaff.isEmpty
              ? const _EmptyStaff('Chưa có nhân viên đang hoạt động')
              : ListView.builder(padding: const EdgeInsets.fromLTRB(12, 10, 12, 20), itemCount: _activeStaff.length, itemBuilder: (_, i) => _StaffCard(
                  staff: _activeStaff[i],
                  onChangeRole: () => _showChangeRoleSheet(context, _activeStaff[i]),
                  onDeactivate: () => _confirmDeactivate(context, _activeStaff[i]),
                )),
          // Tab 2: Inactive
          _inactiveStaff.isEmpty
              ? const _EmptyStaff('Không có nhân viên đã nghỉ')
              : ListView.builder(padding: const EdgeInsets.fromLTRB(12, 10, 12, 20), itemCount: _inactiveStaff.length, itemBuilder: (_, i) => _StaffCard(
                  staff: _inactiveStaff[i],
                  onReactivate: () => _confirmReactivate(context, _inactiveStaff[i]),
                )),
          // Tab 3: Invites
          _invites.isEmpty
              ? const _EmptyStaff('Chưa có lời mời nào')
              : ListView.builder(padding: const EdgeInsets.fromLTRB(12, 10, 12, 20), itemCount: _invites.length, itemBuilder: (_, i) => _InviteCard(
                  invite: _invites[i],
                  onRevoke: () => setState(() => _invites[i] = StaffInviteModel(id:_invites[i].id, venueId:_invites[i].venueId, inviteEmail:_invites[i].inviteEmail, role:_invites[i].role, status:StaffInviteStatus.REVOKED, expiresAt:_invites[i].expiresAt, createdAt:_invites[i].createdAt)),
                )),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteSheet(context),
        backgroundColor: _brand,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('Mời Nhân Viên', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showInviteSheet(BuildContext context) {
    final emailCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    StaffRole selectedRole = StaffRole.STAFF;
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          const Row(children: [Icon(Icons.person_add_rounded, color: Color(0xFF0891B2)), SizedBox(width: 8), Text('Mời Nhân Viên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'Email nhân viên *', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 12),
          const Text('Vai trò', style: TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [StaffRole.MANAGER, StaffRole.STAFF, StaffRole.RECEPTIONIST].map((r) => GestureDetector(
            onTap: () => ss(() => selectedRole = r),
            child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: selectedRole == r ? const Color(0xFF0891B2) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: selectedRole == r ? const Color(0xFF0891B2) : AppColors.borderLight)),
              child: Column(children: [
                Text(r.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text(r.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: selectedRole == r ? Colors.white : AppColors.textSecondary)),
              ])),
          )).toList()),
          const SizedBox(height: 12),
          // Role description
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.info.withOpacity(0.08), borderRadius: BorderRadius.circular(10)), child: Text(_roleDesc(selectedRole), style: const TextStyle(fontSize: 11, color: AppColors.info))),
          const SizedBox(height: 12),
          TextField(controller: msgCtrl, maxLines: 2, decoration: InputDecoration(labelText: 'Lời nhắn (tuỳ chọn)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 16),
          const Text('Link mời sẽ hết hạn sau 7 ngày.', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              if (emailCtrl.text.isEmpty || !emailCtrl.text.contains('@')) return;
              Navigator.pop(ctx);
              final now = DateTime.now();
              setState(() => _invites.insert(0, StaffInviteModel(id:'inv${_invites.length+1}', venueId:widget.venueId, inviteEmail:emailCtrl.text, role:selectedRole, status:StaffInviteStatus.PENDING, message:msgCtrl.text.isEmpty ? null : msgCtrl.text, expiresAt:now.add(const Duration(days:7)), createdAt:now)));
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('📧 Đã gửi lời mời đến ${emailCtrl.text}'), backgroundColor: AppColors.success));
              _tabCtrl.animateTo(2);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Gửi Lời Mời', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ])),
      )),
    );
  }

  void _showChangeRoleSheet(BuildContext context, OwnerStaffModel staff) {
    StaffRole newRole = staff.role;
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Text('Thay đổi vai trò: ${staff.fullName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...StaffRole.values.where((r) => r != StaffRole.OWNER).map((r) => GestureDetector(
            onTap: () => ss(() => newRole = r),
            child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: newRole == r ? const Color(0xFF0891B2).withOpacity(0.05) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: newRole == r ? const Color(0xFF0891B2) : AppColors.borderLight)),
              child: Row(children: [
                Text(r.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: newRole == r ? const Color(0xFF0891B2) : AppColors.textPrimary)),
                  Text(_roleDesc(r), style: const TextStyle(fontSize: 10, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                if (newRole == r) const Icon(Icons.check_circle_rounded, color: Color(0xFF0891B2), size: 18),
              ]),
            ),
          )),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() { final idx = _staff.indexWhere((s) => s.id == staff.id); if (idx >= 0) _staff[idx] = OwnerStaffModel(id:staff.id, venueId:staff.venueId, userId:staff.userId, fullName:staff.fullName, email:staff.email, phone:staff.phone, avatarUrl:staff.avatarUrl, role:newRole, isActive:staff.isActive, joinedAt:staff.joinedAt, workStartTime:staff.workStartTime, workEndTime:staff.workEndTime, workDays:staff.workDays, createdAt:staff.createdAt); });
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Cập nhật vai trò → ${newRole.label}'), backgroundColor: AppColors.success));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Lưu thay đổi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ]),
      )),
    );
  }

  void _confirmDeactivate(BuildContext context, OwnerStaffModel staff) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Vô hiệu hoá nhân viên?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text('${staff.fullName} sẽ không còn quyền truy cập staff portal của venue này. Có thể khôi phục lại sau.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
        ElevatedButton(onPressed: () { Navigator.pop(ctx); setState(() { final idx = _staff.indexWhere((s) => s.id == staff.id); if (idx >= 0) _staff[idx] = OwnerStaffModel(id:staff.id, venueId:staff.venueId, userId:staff.userId, fullName:staff.fullName, email:staff.email, phone:staff.phone, role:staff.role, isActive:false, deactivatedAt:DateTime.now(), joinedAt:staff.joinedAt, workDays:staff.workDays, createdAt:staff.createdAt); }); HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${staff.fullName} đã bị vô hiệu hoá'), backgroundColor: AppColors.warning)); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: const Text('Vô hiệu hoá', style: TextStyle(color: Colors.white))),
      ],
    ));
  }

  void _confirmReactivate(BuildContext context, OwnerStaffModel staff) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Khôi phục nhân viên?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text('${staff.fullName} sẽ được khôi phục quyền truy cập.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
        ElevatedButton(onPressed: () { Navigator.pop(ctx); setState(() { final idx = _staff.indexWhere((s) => s.id == staff.id); if (idx >= 0) _staff[idx] = OwnerStaffModel(id:staff.id, venueId:staff.venueId, userId:staff.userId, fullName:staff.fullName, email:staff.email, phone:staff.phone, role:staff.role, isActive:true, joinedAt:staff.joinedAt, workDays:staff.workDays, createdAt:staff.createdAt); }); HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ ${staff.fullName} đã được khôi phục'), backgroundColor: AppColors.success)); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: const Text('Khôi phục', style: TextStyle(color: Colors.white))),
      ],
    ));
  }

  String _roleDesc(StaffRole r) => switch (r) {
    StaffRole.MANAGER      => 'Toàn quyền: quản lý booking, staff, dịch vụ, bảng giá.',
    StaffRole.STAFF        => 'Vận hành hàng ngày: check-in, lịch sân, thêm addon cho booking.',
    StaffRole.RECEPTIONIST => 'Chỉ check-in và xem lịch booking hôm nay.',
    StaffRole.OWNER        => 'Chủ sân — toàn quyền.',
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
      StaffRole.MANAGER      => const Color(0xFF7C3AED),
      StaffRole.STAFF        => brand,
      StaffRole.RECEPTIONIST => AppColors.success,
      StaffRole.OWNER        => AppColors.warning,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: staff.isActive ? 1.0 : 0.55,
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(12), child: Row(children: [
            // Avatar
            Container(width: 44, height: 44, decoration: BoxDecoration(color: roleColor.withOpacity(0.15), shape: BoxShape.circle),
              child: Center(child: Text(staff.fullName[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: roleColor)))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(staff.fullName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text('${staff.role.emoji} ${staff.role.label}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: roleColor))),
              ]),
              const SizedBox(height: 2),
              if (staff.email != null) Text(staff.email!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
              if (staff.phone != null) Text(staff.phone!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
            ])),
          ])),
          // Work schedule
          if (staff.isActive && staff.workDays.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 8), child: Row(children: [
              const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textHint),
              const SizedBox(width: 6),
              if (staff.workStartTime != null) Text('${staff.workStartTime} – ${staff.workEndTime}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(width: 10),
              Expanded(child: Wrap(spacing: 3, children: staff.workDays.map((d) => Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(d.short, style: const TextStyle(fontSize: 9, color: Color(0xFF0891B2), fontWeight: FontWeight.bold)))).toList())),
            ])),
          ],
          // Actions
          const Divider(height: 1, color: AppColors.borderLight),
          Padding(padding: const EdgeInsets.fromLTRB(10, 6, 10, 8), child: Row(children: [
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
  final StaffInviteModel invite; final VoidCallback onRevoke;
  const _InviteCard({required this.invite, required this.onRevoke});
  @override
  Widget build(BuildContext context) {
    final statusColor = switch (invite.status) {
      StaffInviteStatus.PENDING  => AppColors.warning,
      StaffInviteStatus.ACCEPTED => AppColors.success,
      StaffInviteStatus.REJECTED => AppColors.error,
      StaffInviteStatus.EXPIRED  => AppColors.textHint,
      StaffInviteStatus.REVOKED  => AppColors.textHint,
    };
    final roleColor = switch (invite.role) {
      StaffRole.MANAGER      => const Color(0xFF7C3AED),
      StaffRole.STAFF        => const Color(0xFF0891B2),
      StaffRole.RECEPTIONIST => AppColors.success,
      StaffRole.OWNER        => AppColors.warning,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Center(child: Icon(Icons.email_rounded, color: statusColor, size: 20))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(invite.inviteEmail, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text('${invite.role.emoji} ${invite.role.label}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: roleColor))),
            const SizedBox(width: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(invite.status.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor))),
          ]),
        ])),
        if (invite.status == StaffInviteStatus.PENDING)
          GestureDetector(onTap: onRevoke, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('Thu hồi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error)))),
      ]),
    );
  }
}

class _EmptyStaff extends StatelessWidget {
  final String msg; const _EmptyStaff(this.msg);
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.people_outline_rounded, size: 48, color: AppColors.textHint), const SizedBox(height: 12), Text(msg, style: const TextStyle(color: AppColors.textHint))]));
}

class _SChip extends StatelessWidget {
  final String label; final Color color; const _SChip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)));
}

class _Btn extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _Btn(this.icon, this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () { HapticFeedback.selectionClick(); onTap(); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))])));
}
