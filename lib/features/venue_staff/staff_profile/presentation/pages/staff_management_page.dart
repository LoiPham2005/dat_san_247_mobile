import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/models/staff_schedule_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-08: Staff Management [MANAGER only]
// DB: venue_staff (venue_id, is_active) + users
// ══════════════════════════════════════════════════════════════════════════════
class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF7C3AED);
  late TabController _tabs;
  String? _filterRole;

  final List<VenueStaffMemberModel> _staff = _buildMock();

  static List<VenueStaffMemberModel> _buildMock() => [
    VenueStaffMemberModel(id:'vs1', userId:'u1', fullName:'Nguyễn Thị Thu Hà', phone:'0912345678', role:VenueStaffRole.MANAGER, isActive:true, joinedAt:DateTime(2025,1,1), workStartTime:'08:00', workEndTime:'17:00', workDays:['MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY']),
    VenueStaffMemberModel(id:'vs2', userId:'u2', fullName:'Trần Thị Nhân Viên', phone:'0987654321', role:VenueStaffRole.STAFF, isActive:true, joinedAt:DateTime(2026,1,1), workStartTime:'14:00', workEndTime:'22:00', workDays:['MONDAY','WEDNESDAY','FRIDAY','SATURDAY','SUNDAY']),
    VenueStaffMemberModel(id:'vs3', userId:'u3', fullName:'Phạm Văn Cường', phone:'0905123456', role:VenueStaffRole.STAFF, isActive:true, joinedAt:DateTime(2025,6,1), workStartTime:'06:00', workEndTime:'14:00', workDays:['TUESDAY','THURSDAY','SATURDAY']),
    VenueStaffMemberModel(id:'vs4', userId:'u4', fullName:'Lê Thị Diệu', phone:'0908765432', role:VenueStaffRole.RECEPTIONIST, isActive:true, joinedAt:DateTime(2025,9,1), workStartTime:'08:00', workEndTime:'16:00', workDays:['MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY']),
    VenueStaffMemberModel(id:'vs5', userId:'u5', fullName:'Hoàng Văn Đức', phone:'0917234567', role:VenueStaffRole.STAFF, isActive:false, joinedAt:DateTime(2025,3,1), deactivatedAt:DateTime(2026,2,1), workDays:[]),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  List<VenueStaffMemberModel> get _activeStaff => _staff.where((s) => s.isActive && (_filterRole == null || s.role.name == _filterRole)).toList();
  List<VenueStaffMemberModel> get _inactiveStaff => _staff.where((s) => !s.isActive).toList();

  int _totalRole(VenueStaffRole role) => _staff.where((s) => s.isActive && s.role == role).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: _brand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_rounded, color: Colors.white),
                onPressed: () => _showInviteSheet(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 44, 20, 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Quản Lý Nhân Viên', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      const Text('Sân K34 Phạm Văn Đồng', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 12),
                      Row(children: [
                        _StatPill('👑 ${_totalRole(VenueStaffRole.MANAGER)}', 'MANAGER'),
                        const SizedBox(width: 8),
                        _StatPill('👤 ${_totalRole(VenueStaffRole.STAFF)}', 'STAFF'),
                        const SizedBox(width: 8),
                        _StatPill('🎧 ${_totalRole(VenueStaffRole.RECEPTIONIST)}', 'RECEPTIONIST'),
                      ]),
                    ]),
                  ),
                ),
              ),
              title: const Text('Nhân Viên', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: Container(
                color: _brand,
                child: TabBar(
                  controller: _tabs,
                  indicatorColor: Colors.white,
                  indicatorWeight: 2,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: [
                    Tab(text: 'Đang hoạt động (${_staff.where((s) => s.isActive).length})'),
                    Tab(text: 'Đã vô hiệu (${_inactiveStaff.length})'),
                  ],
                ),
              ),
            ),
          ),
          // Role filter
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _RoleFilter(label: 'Tất cả', selected: _filterRole == null, onTap: () => setState(() => _filterRole = null)),
                  _RoleFilter(label: '👑 MANAGER', selected: _filterRole == 'MANAGER', onTap: () => setState(() => _filterRole = _filterRole == 'MANAGER' ? null : 'MANAGER'), color: AppColors.warning),
                  _RoleFilter(label: '👤 STAFF', selected: _filterRole == 'STAFF', onTap: () => setState(() => _filterRole = _filterRole == 'STAFF' ? null : 'STAFF'), color: _brand),
                  _RoleFilter(label: '🎧 RECEPTIONIST', selected: _filterRole == 'RECEPTIONIST', onTap: () => setState(() => _filterRole = _filterRole == 'RECEPTIONIST' ? null : 'RECEPTIONIST'), color: AppColors.info),
                ]),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            // ── Active staff ──
            _activeStaff.isEmpty
                ? const Center(child: Text('Không có nhân viên', style: TextStyle(color: AppColors.textHint)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                    itemCount: _activeStaff.length,
                    itemBuilder: (_, i) => _StaffCard(
                      member: _activeStaff[i],
                      brand: _brand,
                      canDeactivate: _activeStaff[i].canBeDeactivated,
                      onDeactivate: () => _confirmDeactivate(context, _activeStaff[i]),
                      onTap: () => _showStaffDetail(context, _activeStaff[i]),
                    ),
                  ),

            // ── Inactive staff ──
            _inactiveStaff.isEmpty
                ? const Center(child: Text('Không có', style: TextStyle(color: AppColors.textHint)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                    itemCount: _inactiveStaff.length,
                    itemBuilder: (_, i) => _StaffCard(
                      member: _inactiveStaff[i],
                      brand: _brand,
                      canDeactivate: false,
                      onDeactivate: () {},
                      onTap: () => _showStaffDetail(context, _inactiveStaff[i]),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteSheet(context),
        backgroundColor: _brand,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('Mời nhân viên', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _confirmDeactivate(BuildContext context, VenueStaffMemberModel member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.person_off_rounded, color: AppColors.error),
          const SizedBox(width: 8),
          const Text('Vô hiệu hóa?', style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text('Vô hiệu hóa tài khoản của ${member.fullName}?\nNhân viên sẽ không thể đăng nhập Staff Portal.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              HapticFeedback.heavyImpact();
              setState(() {
                final idx = _staff.indexWhere((s) => s.id == member.id);
                if (idx >= 0) {
                  _staff[idx] = VenueStaffMemberModel(
                    id: member.id, userId: member.userId, fullName: member.fullName,
                    phone: member.phone, role: member.role, isActive: false,
                    joinedAt: member.joinedAt, deactivatedAt: DateTime.now(),
                    workDays: member.workDays,
                  );
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('⛔ Đã vô hiệu hóa: ${member.fullName}'), backgroundColor: AppColors.error),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showStaffDetail(BuildContext context, VenueStaffMemberModel m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false, initialChildSize: 0.6, maxChildSize: 0.9,
        builder: (_, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            // Header
            Row(children: [
              _Avatar(name: m.fullName, role: m.role, size: 32, brand: _brand),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (m.phone != null) Text(m.phone!, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
              ])),
              _RoleBadge(role: m.role),
            ]),
            const Divider(height: 20, color: AppColors.borderLight),
            _DetailRow(icon: Icons.calendar_today_rounded, label: 'Ngày tham gia', value: m.joinedAt != null ? DateFormat('dd/MM/yyyy').format(m.joinedAt!) : '—'),
            _DetailRow(icon: Icons.access_time_rounded, label: 'Ca làm việc', value: m.workStartTime != null ? '${m.workStartTime} – ${m.workEndTime}' : 'Chưa cài'),
            _DetailRow(icon: Icons.calendar_view_week_rounded, label: 'Ngày làm', value: m.workDaysLabel.isEmpty ? 'Chưa cài' : m.workDaysLabel),
            if (m.note != null && m.note!.isNotEmpty)
              _DetailRow(icon: Icons.notes_rounded, label: 'Ghi chú', value: m.note!),
            if (!m.isActive && m.deactivatedAt != null) ...[
              const Divider(height: 20, color: AppColors.borderLight),
              _DetailRow(icon: Icons.do_not_disturb_rounded, label: 'Bị vô hiệu lúc', value: DateFormat('HH:mm dd/MM/yyyy').format(m.deactivatedAt!), color: AppColors.error),
            ],
          ],
        ),
      ),
    );
  }

  void _showInviteSheet(BuildContext context) {
    final emailCtrl = TextEditingController();
    VenueStaffRole role = VenueStaffRole.STAFF;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 14),
              const Row(children: [
                Icon(Icons.person_add_rounded, color: Color(0xFF7C3AED)),
                SizedBox(width: 8),
                Text('Mời Nhân Viên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email nhân viên',
                  hintText: 'example@gmail.com',
                  prefixIcon: const Icon(Icons.email_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Vai trò', style: TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(children: VenueStaffRole.values.map((r) => Expanded(child: GestureDetector(
                onTap: () => ss(() => role = r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: role == r ? const Color(0xFF7C3AED) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: role == r ? const Color(0xFF7C3AED) : AppColors.borderLight),
                  ),
                  child: Column(children: [
                    Text(r == VenueStaffRole.MANAGER ? '👑' : r == VenueStaffRole.STAFF ? '👤' : '🎧', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 2),
                    Text(r.name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: role == r ? Colors.white : AppColors.textSecondary)),
                  ]),
                ),
              ))).toList()),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('📧 Đã gửi lời mời qua email'), backgroundColor: AppColors.success),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  label: const Text('Gửi lời mời', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED), elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StaffCard extends StatelessWidget {
  final VenueStaffMemberModel member;
  final Color brand;
  final bool canDeactivate;
  final VoidCallback onDeactivate;
  final VoidCallback onTap;

  const _StaffCard({required this.member, required this.brand, required this.canDeactivate, required this.onDeactivate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final m = member;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: m.isActive ? AppColors.borderLight : AppColors.error.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _Avatar(name: m.fullName, role: m.role, size: 24, brand: brand),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(m.fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                _RoleBadge(role: m.role),
              ]),
              if (m.phone != null) ...[
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.phone_rounded, size: 11, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(m.phone!, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ]),
              ],
            ])),
          ]),

          const SizedBox(height: 10),

          // Work schedule
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: brand.withOpacity(0.04), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textHint),
              const SizedBox(width: 6),
              if (m.workStartTime != null)
                Text('${m.workStartTime} – ${m.workEndTime}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
              else
                const Text('Chưa cài ca', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
              if (m.workDaysLabel.isNotEmpty) ...[
                const SizedBox(width: 8),
                Expanded(child: Text(m.workDaysLabel, style: const TextStyle(fontSize: 10, color: AppColors.textHint), overflow: TextOverflow.ellipsis)),
              ],
            ]),
          ),

          // Deactivated info
          if (!m.isActive && m.deactivatedAt != null) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.do_not_disturb_rounded, size: 11, color: AppColors.error),
              const SizedBox(width: 4),
              Text('Vô hiệu lúc ${DateFormat('dd/MM/yyyy').format(m.deactivatedAt!)}',
                  style: const TextStyle(fontSize: 10, color: AppColors.error)),
            ]),
          ],

          // Actions
          if (m.isActive && canDeactivate) ...[
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton.icon(
                onPressed: onDeactivate,
                icon: const Icon(Icons.person_off_rounded, size: 13),
                label: const Text('Vô hiệu'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ]),
          ],
        ]),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final VenueStaffRole role;
  final double size;
  final Color brand;
  const _Avatar({required this.name, required this.role, required this.size, required this.brand});

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      VenueStaffRole.OWNER       => AppColors.error,
      VenueStaffRole.MANAGER     => AppColors.warning,
      VenueStaffRole.RECEPTIONIST => AppColors.info,
      VenueStaffRole.STAFF       => brand,
    };
    return CircleAvatar(
      radius: size,
      backgroundColor: color.withOpacity(0.15),
      child: Text(name[0], style: TextStyle(fontSize: size * 0.7, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final VenueStaffRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (role) {
      VenueStaffRole.OWNER        => (AppColors.error, '🔑 Owner'),
      VenueStaffRole.MANAGER      => (AppColors.warning, '👑 Manager'),
      VenueStaffRole.RECEPTIONIST => (AppColors.info, '🎧 Receptionist'),
      VenueStaffRole.STAFF        => (const Color(0xFF7C3AED), '👤 Staff'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value, label;
  const _StatPill(this.value, this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
    child: Column(children: [
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    ]),
  );
}

class _RoleFilter extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  const _RoleFilter({required this.label, required this.selected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? (color ?? const Color(0xFF7C3AED)) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? (color ?? const Color(0xFF7C3AED)) : AppColors.borderLight),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textSecondary)),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final IconData icon; final String label, value; final Color? color;
  const _DetailRow({required this.icon, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Icon(icon, size: 15, color: AppColors.textHint),
      const SizedBox(width: 10),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color ?? AppColors.textPrimary)),
    ]),
  );
}
