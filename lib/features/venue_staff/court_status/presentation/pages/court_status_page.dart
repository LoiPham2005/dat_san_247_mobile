import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-07: Court Status — Realtime status, next booking, maintenance
// DB: courts, bookings (current time range), court_maintenance
// ══════════════════════════════════════════════════════════════════════════════
class CourtStatusPage extends StatefulWidget {
  final bool isManager; // VS-07: MANAGER can create maintenance
  const CourtStatusPage({super.key, this.isManager = false});

  @override
  State<CourtStatusPage> createState() => _CourtStatusPageState();
}

class _CourtStatusPageState extends State<CourtStatusPage> {
  static const Color _brand = Color(0xFF7C3AED);

  late List<CourtStatusModel> _courts = _buildMock();

  static List<CourtStatusModel> _buildMock() {
    final now = DateTime.now();
    return [
      CourtStatusModel(id:'c1', name:'Sân A', isIndoor:false, isActive:true, surfaceType:'ARTIFICIAL_GRASS', size:'5 người', pricePerHour:150000, displayOrder:1,
        currentBookingId:'b2', currentCustomerName:'Trần Thị Bình', currentCustomerPhone:'0987654321', currentStartTime:'09:00', currentEndTime:'10:30', currentBookingCode:'DS24799102',
        nextCustomerName:'Phạm Văn Cường', nextStartTime:'18:00',
        todayBookingCount:4, todayCheckedInCount:2),
      CourtStatusModel(id:'c2', name:'Sân B', isIndoor:false, isActive:true, surfaceType:'ARTIFICIAL_GRASS', size:'7 người', pricePerHour:200000, displayOrder:2,
        nextCustomerName:'Lê Hoàng Dũng', nextStartTime:'20:00',
        todayBookingCount:3, todayCheckedInCount:1),
      CourtStatusModel(id:'c3', name:'Sân CL', isIndoor:true, isActive:true, surfaceType:'WOOD', size:'Cầu Lông', pricePerHour:80000, displayOrder:3,
        activeMaintenance: CourtMaintenanceModel(id:'m1', courtId:'c3',
          startAt:DateTime(now.year,now.month,now.day,8,0),
          endAt:DateTime(now.year,now.month,now.day,11,0),
          reason:'Thay lưới cầu lông định kỳ', isEmergency:false),
        todayBookingCount:2, todayCheckedInCount:1),
      CourtStatusModel(id:'c4', name:'Sân D', isIndoor:false, isActive:true, surfaceType:'ARTIFICIAL_GRASS', size:'5 người', pricePerHour:150000, displayOrder:4,
        todayBookingCount:3, todayCheckedInCount:0),
      CourtStatusModel(id:'c5', name:'Sân E', isIndoor:false, isActive:false, surfaceType:'ARTIFICIAL_GRASS', size:'11 người', pricePerHour:300000, displayOrder:5,
        todayBookingCount:0, todayCheckedInCount:0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final available = _courts.where((c) => c.statusNow == CourtStatusNow.available).length;
    final occupied = _courts.where((c) => c.statusNow == CourtStatusNow.occupied).length;
    final maintenance = _courts.where((c) => c.statusNow == CourtStatusNow.maintenance).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: _brand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (widget.isManager)
                TextButton.icon(
                  onPressed: () => _showAddMaintenanceSheet(context),
                  icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  label: const Text('Bảo trì', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                      Row(children: [
                        const Text('Trạng Thái Sân', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                        const Spacer(),
                        Text(DateFormat('HH:mm').format(DateTime.now()), style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        _QuickStat('$available', 'Trống', AppColors.success),
                        const SizedBox(width: 16),
                        _QuickStat('$occupied', 'Đang dùng', const Color(0xFF38BDF8)),
                        const SizedBox(width: 16),
                        _QuickStat('$maintenance', 'Bảo trì', AppColors.error),
                        const SizedBox(width: 16),
                        _QuickStat('${_courts.length}', 'Tổng sân', Colors.white70),
                      ]),
                    ]),
                  ),
                ),
              ),
              title: const Text('Trạng thái sân', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

          // ── Refresh hint ──
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(children: [
                const Icon(Icons.refresh_rounded, size: 13, color: AppColors.textHint),
                const SizedBox(width: 5),
                Text('Cập nhật lúc ${DateFormat('HH:mm:ss').format(DateTime.now())}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                const Spacer(),
                GestureDetector(
                  onTap: () { HapticFeedback.selectionClick(); setState(() => _courts = _buildMock()); },
                  child: Text('Làm mới', style: TextStyle(fontSize: 11, color: _brand, fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
          ),

          // ── Court cards ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _CourtDetailCard(
                court: _courts[i],
                isManager: widget.isManager,
                brand: _brand,
                onToggleMaintenance: (court) => _showAddMaintenanceSheet(context, courtId: court.id, courtName: court.name),
              ),
              childCount: _courts.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  void _showAddMaintenanceSheet(BuildContext context, {String? courtId, String? courtName}) {
    final formKey = GlobalKey<FormState>();
    final reasonCtrl = TextEditingController();
    String? selectedCourt = courtId;
    bool isEmergency = false;
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                const Text('🔧 Tạo Bảo Trì', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Court selector
                if (courtId == null) ...[
                  const Text('Chọn sân', style: TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCourt,
                        hint: const Text('Chọn sân', style: TextStyle(fontSize: 13)),
                        items: _courts.where((c) => c.isActive).map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                        onChanged: (v) => setStateSheet(() => selectedCourt = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  Row(children: [
                    const Icon(Icons.sports_soccer_rounded, size: 16, color: AppColors.textHint),
                    const SizedBox(width: 8),
                    Text('Sân: $courtName', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 12),
                ],
                // Time pickers
                Row(children: [
                  Expanded(child: _TimePicker(label: 'Bắt đầu', time: startTime, onPick: (t) => setStateSheet(() => startTime = t))),
                  const SizedBox(width: 12),
                  Expanded(child: _TimePicker(label: 'Kết thúc', time: endTime, onPick: (t) => setStateSheet(() => endTime = t))),
                ]),
                const SizedBox(height: 12),
                // Reason
                TextFormField(
                  controller: reasonCtrl,
                  decoration: InputDecoration(
                    labelText: 'Lý do bảo trì',
                    hintText: 'VD: Thay lưới, kiểm tra đèn...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  maxLines: 2,
                  validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập lý do' : null,
                ),
                const SizedBox(height: 12),
                // Emergency toggle
                GestureDetector(
                  onTap: () { HapticFeedback.selectionClick(); setStateSheet(() => isEmergency = !isEmergency); },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isEmergency ? AppColors.error.withOpacity(0.08) : AppColors.borderLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isEmergency ? AppColors.error.withOpacity(0.4) : AppColors.borderLight),
                    ),
                    child: Row(children: [
                      Icon(Icons.warning_rounded, color: isEmergency ? AppColors.error : AppColors.textHint, size: 20),
                      const SizedBox(width: 10),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Bảo trì khẩn cấp', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isEmergency ? AppColors.error : AppColors.textPrimary)),
                        const Text('Ưu tiên xử lý ngay lập tức', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
                      ]),
                      const Spacer(),
                      Switch(value: isEmergency, onChanged: (v) => setStateSheet(() => isEmergency = v), activeColor: AppColors.error),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() != true) return;
                      HapticFeedback.heavyImpact();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ Đã tạo lịch bảo trì${isEmergency ? " (KHẨN CẤP)" : ""}'),
                          backgroundColor: isEmergency ? AppColors.error : AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmergency ? AppColors.error : _brand,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEmergency ? '⚠️ Tạo Bảo Trì Khẩn Cấp' : 'Tạo Bảo Trì',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final void Function(TimeOfDay) onPick;
  const _TimePicker({required this.label, required this.time, required this.onPick});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async {
      final t = await showTimePicker(context: context, initialTime: time);
      if (t != null) onPick(t);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
          Text('${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ]),
      ]),
    ),
  );
}

// ── Court detail card ─────────────────────────────────────────────────────────
class _CourtDetailCard extends StatelessWidget {
  final CourtStatusModel court;
  final bool isManager;
  final Color brand;
  final void Function(CourtStatusModel) onToggleMaintenance;

  const _CourtDetailCard({required this.court, required this.isManager, required this.brand, required this.onToggleMaintenance});

  @override
  Widget build(BuildContext context) {
    final status = court.statusNow;
    final (dotColor, bgColor, icon) = switch (status) {
      CourtStatusNow.available   => (AppColors.success, AppColors.success.withOpacity(0.06), Icons.sports_soccer_rounded),
      CourtStatusNow.occupied    => (brand, brand.withOpacity(0.06), Icons.people_rounded),
      CourtStatusNow.reserved    => (AppColors.warning, AppColors.warning.withOpacity(0.06), Icons.event_rounded),
      CourtStatusNow.maintenance => (AppColors.error, AppColors.error.withOpacity(0.06), Icons.build_rounded),
      CourtStatusNow.inactive    => (AppColors.textHint, AppColors.textHint.withOpacity(0.06), Icons.block_rounded),
    };

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dotColor.withOpacity(0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Court header ──
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor.withOpacity(2), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: dotColor),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(court.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Row(children: [
              Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 5), decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
              Text(status.label, style: TextStyle(fontSize: 11, color: dotColor, fontWeight: FontWeight.bold)),
            ]),
          ])),
          // Stats
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            _StatChip('${court.todayBookingCount} booking', Colors.grey),
            const SizedBox(height: 3),
            _StatChip('${court.todayCheckedInCount} check-in', AppColors.success),
          ]),
        ]),

        const Divider(height: 14, color: AppColors.borderLight),

        // ── Current / context info ──
        if (status == CourtStatusNow.occupied) _OccupiedInfo(court: court, brand: brand)
        else if (status == CourtStatusNow.maintenance) _MaintenanceInfo(m: court.activeMaintenance!)
        else if (status == CourtStatusNow.reserved) _ReservedInfo(court: court)
        else if (status == CourtStatusNow.available) _AvailableInfo(court: court),

        // ── Next booking ──
        if (status == CourtStatusNow.occupied && court.nextStartTime != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.schedule_rounded, size: 13, color: AppColors.warning),
              const SizedBox(width: 6),
              Text('Booking tiếp: ${court.nextStartTime} – ${court.nextCustomerName ?? ''}',
                  style: const TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],

        // ── Actions (Manager only) ──
        if (isManager && status != CourtStatusNow.inactive) ...[
          const SizedBox(height: 10),
          Row(children: [
            if (status != CourtStatusNow.maintenance)
              Expanded(child: OutlinedButton.icon(
                onPressed: () => onToggleMaintenance(court),
                icon: const Icon(Icons.build_rounded, size: 14),
                label: const Text('Bảo trì', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.warning,
                  side: BorderSide(color: AppColors.warning.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              )),
            if (status == CourtStatusNow.maintenance) ...[
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_rounded, size: 14),
                label: const Text('Kết thúc bảo trì', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: BorderSide(color: AppColors.success.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ]),
        ],
      ]),
    );
  }
}

class _OccupiedInfo extends StatelessWidget {
  final CourtStatusModel court;
  final Color brand;
  const _OccupiedInfo({required this.court, required this.brand});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: brand.withOpacity(0.12),
        child: Text(court.currentCustomerName?[0] ?? '?', style: TextStyle(color: brand, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(court.currentCustomerName ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        if (court.currentCustomerPhone != null)
          Text(court.currentCustomerPhone!, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('${court.currentStartTime} – ${court.currentEndTime}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brand)),
        if (court.currentBookingCode != null)
          Text(court.currentBookingCode!, style: const TextStyle(fontSize: 9, color: AppColors.textHint, fontFamily: 'monospace')),
      ]),
    ]),
  ]);
}

class _MaintenanceInfo extends StatelessWidget {
  final CourtMaintenanceModel m;
  const _MaintenanceInfo({required this.m});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: m.isEmergency ? AppColors.error.withOpacity(0.08) : AppColors.warning.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(m.isEmergency ? Icons.warning_rounded : Icons.build_rounded, size: 14, color: m.isEmergency ? AppColors.error : AppColors.warning),
        const SizedBox(width: 6),
        Text(m.reason, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: m.isEmergency ? AppColors.error : AppColors.textPrimary)),
        if (m.isEmergency) ...[
          const SizedBox(width: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: const Text('KHẨN CẤP', style: TextStyle(fontSize: 9, color: AppColors.error, fontWeight: FontWeight.bold))),
        ],
      ]),
      const SizedBox(height: 4),
      Text('${DateFormat('HH:mm').format(m.startAt)} – ${DateFormat('HH:mm').format(m.endAt)}',
          style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
    ]),
  );
}

class _ReservedInfo extends StatelessWidget {
  final CourtStatusModel court;
  const _ReservedInfo({required this.court});

  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.event_rounded, size: 14, color: AppColors.warning),
    const SizedBox(width: 8),
    Text('Đặt từ ${court.nextStartTime}', style: const TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.bold)),
    if (court.nextCustomerName != null) ...[
      const Text(' – ', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
      Text(court.nextCustomerName!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    ],
  ]);
}

class _AvailableInfo extends StatelessWidget {
  final CourtStatusModel court;
  const _AvailableInfo({required this.court});

  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
    const SizedBox(width: 8),
    const Text('Sân đang trống — sẵn sàng đón khách', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
  ]);
}

class _QuickStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _QuickStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
    Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
  ]);
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatChip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
  );
}
