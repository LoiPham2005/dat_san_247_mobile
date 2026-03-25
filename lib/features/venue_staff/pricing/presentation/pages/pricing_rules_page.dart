import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/data/models/pricing_models.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-09: Bảng Giá [MANAGER only]
// DB: pricing_rules (court_id IN venue), courts
// ══════════════════════════════════════════════════════════════════════════════
@route
class PricingRulesPage extends StatefulWidget {
  const PricingRulesPage({super.key});

  @override
  State<PricingRulesPage> createState() => _PricingRulesPageState();
}

class _PricingRulesPageState extends State<PricingRulesPage> {
  static const Color _brand = Color(0xFF7C3AED);
  String? _selectedCourtId;
  bool _showInactive = false;

  // Mock courts
  final _courts = [
    _CourtRef('c1', 'Sân A'),
    _CourtRef('c2', 'Sân B'),
    _CourtRef('c3', 'Sân CL'),
    _CourtRef('c4', 'Sân D'),
  ];

  late List<PricingRuleModel> _rules = _buildMock();

  static List<PricingRuleModel> _buildMock() {
    final now = DateTime.now();
    return [
      // Sân A
      PricingRuleModel(id:'r1', courtId:'c1', courtName:'Sân A', name:'Sáng thường', dayOfWeek:'MONDAY', startTime:'06:00', endTime:'11:30', price:120000, priority:1, isActive:true, updatedAt:now),
      PricingRuleModel(id:'r2', courtId:'c1', courtName:'Sân A', name:'Giờ vàng T2-T6', dayOfWeek:'MONDAY', startTime:'17:00', endTime:'21:30', price:200000, priority:2, isActive:true, updatedAt:now),
      PricingRuleModel(id:'r3', courtId:'c1', courtName:'Sân A', name:'Cuối tuần sáng', dayOfWeek:'SATURDAY', startTime:'06:00', endTime:'12:00', price:150000, priority:1, isActive:true, updatedAt:now),
      PricingRuleModel(id:'r4', courtId:'c1', courtName:'Sân A', name:'Cuối tuần tối', dayOfWeek:'SATURDAY', startTime:'17:00', endTime:'22:00', price:220000, priority:2, isActive:true, updatedAt:now),
      PricingRuleModel(id:'r5', courtId:'c1', courtName:'Sân A', name:'Tiêu chuẩn', startTime:'06:00', endTime:'22:00', price:150000, priority:0, isActive:true, updatedAt:now),
      // Sân B
      PricingRuleModel(id:'r6', courtId:'c2', courtName:'Sân B', name:'Tiêu chuẩn T2-T6', startTime:'06:00', endTime:'17:00', price:160000, priority:0, isActive:true, updatedAt:now),
      PricingRuleModel(id:'r7', courtId:'c2', courtName:'Sân B', name:'Giờ cao điểm', dayOfWeek:'FRIDAY', startTime:'17:00', endTime:'22:00', price:250000, priority:3, isActive:true, updatedAt:now),
      PricingRuleModel(id:'r8', courtId:'c2', courtName:'Sân B', name:'Khuyến mãi cũ', startTime:'06:00', endTime:'22:00', price:130000, priority:1, isActive:false, updatedAt:now),
      // Sân CL
      PricingRuleModel(id:'r9', courtId:'c3', courtName:'Sân CL', name:'Cầu lông thường', startTime:'06:00', endTime:'17:00', price:60000, priority:0, isActive:true, updatedAt:now),
      PricingRuleModel(id:'r10', courtId:'c3', courtName:'Sân CL', name:'Cầu lông tối', startTime:'17:00', endTime:'22:00', price:80000, priority:1, isActive:true, updatedAt:now),
    ];
  }

  List<PricingRuleModel> get _filtered {
    var list = _rules.where((r) => (_selectedCourtId == null || r.courtId == _selectedCourtId)).toList();
    if (!_showInactive) list = list.where((r) => r.isActive).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByCourt(_filtered);
    final totalActive = _rules.where((r) => r.isActive).length;
    final totalInactive = _rules.where((r) => !r.isActive).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: _brand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                onPressed: () => _showEditSheet(context, null),
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
                      const Text('Bảng Giá', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      const Text('👑 MANAGER — Quản lý giá theo khung giờ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 10),
                      Row(children: [
                        _StatBadge('$totalActive đang dùng', AppColors.success),
                        const SizedBox(width: 8),
                        _StatBadge('$totalInactive tắt', Colors.white60),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _showInactive = !_showInactive),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(_showInactive ? 0.3 : 0.15), borderRadius: BorderRadius.circular(20)),
                            child: Text(_showInactive ? 'Ẩn tắt' : 'Hiện tắt', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                ),
              ),
              title: const Text('Bảng Giá', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

          // ── Court filter ──
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _CourtPill(label: 'Tất cả', selected: _selectedCourtId == null, brand: _brand, onTap: () => setState(() => _selectedCourtId = null)),
                  ..._courts.map((c) => _CourtPill(label: c.name, selected: _selectedCourtId == c.id, brand: _brand,
                      count: _rules.where((r) => r.courtId == c.id && r.isActive).length,
                      onTap: () => setState(() => _selectedCourtId = c.id))),
                ]),
              ),
            ),
          ),

          // ── Content ──
          if (grouped.isEmpty)
            const SliverFillRemaining(child: Center(child: Text('Không có quy tắc giá', style: TextStyle(color: AppColors.textHint))))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final entry = grouped.entries.toList()[i];
                  return _CourtPriceGroup(
                    courtName: entry.key,
                    rules: entry.value,
                    brand: _brand,
                    onToggle: (rule) => setState(() {
                      final idx = _rules.indexWhere((r) => r.id == rule.id);
                      if (idx >= 0) _rules[idx] = rule.copyWith(isActive: !rule.isActive);
                      HapticFeedback.selectionClick();
                    }),
                    onEdit: (rule) => _showEditSheet(context, rule),
                  );
                },
                childCount: grouped.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Map<String, List<PricingRuleModel>> _groupByCourt(List<PricingRuleModel> rules) {
    final map = <String, List<PricingRuleModel>>{};
    for (final r in rules) {
      map.putIfAbsent(r.courtName, () => []).add(r);
    }
    return map;
  }

  void _showEditSheet(BuildContext context, PricingRuleModel? existing) {
    final isNew = existing == null;
    String? selectedCourt = existing?.courtId ?? _courts.first.id;
    String? selectedDay = existing?.dayOfWeek;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final priceCtrl = TextEditingController(text: existing != null ? existing.price.toInt().toString() : '');
    TimeOfDay startT = _toTOD(existing?.startTime ?? '06:00');
    TimeOfDay endT = _toTOD(existing?.endTime ?? '22:00');
    int priority = existing?.priority ?? 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 14),
              Row(children: [
                Icon(isNew ? Icons.add_circle_rounded : Icons.edit_rounded, color: _brand, size: 20),
                const SizedBox(width: 8),
                Text(isNew ? 'Thêm Quy Tắc Giá' : 'Sửa Quy Tắc Giá',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),

              // Court selector
              if (isNew) ...[
                _Label('Sân áp dụng'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true, value: selectedCourt,
                      items: _courts.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                      onChanged: (v) => ss(() => selectedCourt = v),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Name
              _Label('Tên quy tắc (tuỳ chọn)'),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: 'VD: Giờ vàng cuối tuần',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),

              // Day of week
              _Label('Ngày áp dụng'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _DayChip(label: 'Tất cả', selected: selectedDay == null, onTap: () => ss(() => selectedDay = null), brand: _brand),
                  ...['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']
                      .map((d) => _DayChip(
                        label: {'MONDAY':'T2','TUESDAY':'T3','WEDNESDAY':'T4','THURSDAY':'T5','FRIDAY':'T6','SATURDAY':'T7','SUNDAY':'CN'}[d]!,
                        selected: selectedDay == d, onTap: () => ss(() => selectedDay = d), brand: _brand,
                        highlight: d == 'SATURDAY' || d == 'SUNDAY',
                      )),
                ]),
              ),
              const SizedBox(height: 12),

              // Time range
              _Label('Khung giờ'),
              Row(children: [
                Expanded(child: _TimePicker2(label: 'Từ', time: startT, onPick: (t) => ss(() => startT = t))),
                const SizedBox(width: 12),
                Expanded(child: _TimePicker2(label: 'Đến', time: endT, onPick: (t) => ss(() => endT = t))),
              ]),
              const SizedBox(height: 12),

              // Price
              _Label('Giá / giờ (VNĐ)'),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '₫ ',
                  hintText: '150000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),

              // Priority
              _Label('Độ ưu tiên (cao hơn = áp dụng trước)'),
              Row(children: List.generate(5, (i) => GestureDetector(
                onTap: () => ss(() => priority = i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: priority == i + 1 ? _brand : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: priority == i + 1 ? _brand : AppColors.borderLight),
                  ),
                  child: Center(child: Text('${i+1}', style: TextStyle(fontWeight: FontWeight.bold, color: priority == i + 1 ? Colors.white : AppColors.textSecondary))),
                ),
              ))),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final p = double.tryParse(priceCtrl.text) ?? 0;
                    if (p <= 0) return;
                    HapticFeedback.mediumImpact();
                    Navigator.pop(ctx);
                    setState(() {
                      if (isNew) {
                        _rules.add(PricingRuleModel(
                          id: 'r${_rules.length + 1}',
                          courtId: selectedCourt!, courtName: _courts.firstWhere((c) => c.id == selectedCourt).name,
                          name: nameCtrl.text.isEmpty ? null : nameCtrl.text,
                          dayOfWeek: selectedDay,
                          startTime: _todStr(startT), endTime: _todStr(endT),
                          price: p, priority: priority, isActive: true, updatedAt: DateTime.now(),
                        ));
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isNew ? '✅ Đã thêm quy tắc giá' : '✅ Đã cập nhật giá'), backgroundColor: AppColors.success),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: _brand, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(isNew ? 'Thêm quy tắc' : 'Lưu thay đổi', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  TimeOfDay _toTOD(String s) {
    final p = s.split(':');
    return TimeOfDay(hour: int.tryParse(p[0]) ?? 0, minute: int.tryParse(p.length > 1 ? p[1] : '0') ?? 0);
  }

  String _todStr(TimeOfDay t) => '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
}

// ── Court group widget ────────────────────────────────────────────────────────
class _CourtPriceGroup extends StatelessWidget {
  final String courtName;
  final List<PricingRuleModel> rules;
  final Color brand;
  final void Function(PricingRuleModel) onToggle;
  final void Function(PricingRuleModel) onEdit;

  const _CourtPriceGroup({required this.courtName, required this.rules, required this.brand, required this.onToggle, required this.onEdit});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
        child: Row(children: [
          Container(width: 3, height: 14, decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(courtName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: brand)),
          const SizedBox(width: 8),
          Text('${rules.length} quy tắc', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        ]),
      ),
      ...rules.map((rule) => _PriceRuleCard(rule: rule, onToggle: () => onToggle(rule), onEdit: () => onEdit(rule))),
      const SizedBox(height: 4),
    ],
  );
}

class _PriceRuleCard extends StatelessWidget {
  final PricingRuleModel rule;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  const _PriceRuleCard({required this.rule, required this.onToggle, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    final isPeak = rule.isPeakHour;
    final isWeekend = rule.isWeekend;
    final accentColor = !rule.isActive ? AppColors.textHint
        : isPeak ? AppColors.warning
        : isWeekend ? AppColors.success
        : brand;

    return GestureDetector(
      onTap: onEdit,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: rule.isActive ? 1.0 : 0.55,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: rule.isActive ? accentColor.withOpacity(0.25) : AppColors.borderLight),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
          ),
          child: Row(children: [
            // Left accent bar
            Container(width: 4, height: 48, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (rule.name != null)
                  Expanded(child: Text(rule.name!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis))
                else
                  Expanded(child: Text('${rule.startTime}–${rule.endTime}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                const SizedBox(width: 6),
                if (isPeak) _Tag('⚡ Cao điểm', AppColors.warning),
                if (isWeekend) _Tag('🏖 Cuối tuần', AppColors.success),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.access_time_rounded, size: 11, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('${rule.startTime} – ${rule.endTime}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Icon(Icons.calendar_today_rounded, size: 11, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(rule.dayLabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 2),
              Row(children: [
                Text('P${rule.priority}', style: TextStyle(fontSize: 9, color: accentColor, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Text('Ưu tiên ${rule.priority}', style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
              ]),
            ])),

            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(_fmt(rule.price), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: accentColor)),
              const Text('/giờ', style: TextStyle(fontSize: 9, color: AppColors.textHint)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onToggle,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: rule.isActive ? accentColor.withOpacity(0.1) : AppColors.borderLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: rule.isActive ? accentColor : AppColors.textHint, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(rule.isActive ? 'Bật' : 'Tắt', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: rule.isActive ? accentColor : AppColors.textHint)),
                  ]),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v/1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v/1000).round()}K';
    return v.toStringAsFixed(0);
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────
class _Tag extends StatelessWidget {
  final String label; final Color color;
  const _Tag(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(left: 4),
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
  );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.bold)),
  );
}

class _StatBadge extends StatelessWidget {
  final String label; final Color color;
  const _StatBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
  );
}

class _CourtPill extends StatelessWidget {
  final String label; final bool selected; final Color brand; final VoidCallback onTap; final int count;
  const _CourtPill({required this.label, required this.selected, required this.brand, required this.onTap, this.count = 0});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? brand : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? brand : AppColors.borderLight),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textSecondary)),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Container(width: 16, height: 16, decoration: BoxDecoration(color: selected ? Colors.white.withOpacity(0.3) : brand.withOpacity(0.1), shape: BoxShape.circle),
            child: Center(child: Text('$count', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: selected ? Colors.white : brand)))),
        ],
      ]),
    ),
  );
}

class _DayChip extends StatelessWidget {
  final String label; final bool selected; final Color brand; final VoidCallback onTap; final bool highlight;
  const _DayChip({required this.label, required this.selected, required this.brand, required this.onTap, this.highlight = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? brand : (highlight ? AppColors.success.withOpacity(0.08) : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: selected ? brand : (highlight ? AppColors.success.withOpacity(0.4) : AppColors.borderLight)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : (highlight ? AppColors.success : AppColors.textSecondary))),
    ),
  );
}

class _TimePicker2 extends StatelessWidget {
  final String label; final TimeOfDay time; final void Function(TimeOfDay) onPick;
  const _TimePicker2({required this.label, required this.time, required this.onPick});

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

class _CourtRef { final String id, name; const _CourtRef(this.id, this.name); }
