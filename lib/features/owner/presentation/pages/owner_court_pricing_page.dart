import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/data/models/owner_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-05: Bảng Giá Sân — Owner pricing rules per court
// DB: pricing_rules (court_id), courts
// Ngữ cảnh: Từ O-04 Court Card → "Bảng Giá" button
// ══════════════════════════════════════════════════════════════════════════════
class OwnerCourtPricingPage extends StatefulWidget {
  final OwnerCourtModel court;
  const OwnerCourtPricingPage({super.key, required this.court});

  @override
  State<OwnerCourtPricingPage> createState() => _OwnerCourtPricingPageState();
}

class _OwnerCourtPricingPageState extends State<OwnerCourtPricingPage> {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  late List<OwnerPricingRuleModel> _rules = _buildMock();
  bool _showInactive = false;

  List<OwnerPricingRuleModel> _buildMock() {
    final now = DateTime.now();
    return [
      OwnerPricingRuleModel(id:'r1', courtId:widget.court.id, courtName:widget.court.name, name:'Giờ chuẩn', startTime:'06:00', endTime:'17:00', price:widget.court.pricePerHour, priority:0, isActive:true, updatedAt:now),
      OwnerPricingRuleModel(id:'r2', courtId:widget.court.id, courtName:widget.court.name, name:'Giờ vàng T2–T6', dayOfWeek:'MONDAY', startTime:'17:00', endTime:'21:30', price:widget.court.pricePerHour * 1.4, priority:2, isActive:true, updatedAt:now),
      OwnerPricingRuleModel(id:'r3', courtId:widget.court.id, courtName:widget.court.name, name:'Cuối tuần sáng', dayOfWeek:'SATURDAY', startTime:'06:00', endTime:'12:00', price:widget.court.pricePerHour * 1.2, priority:1, isActive:true, updatedAt:now),
      OwnerPricingRuleModel(id:'r4', courtId:widget.court.id, courtName:widget.court.name, name:'Cuối tuần tối', dayOfWeek:'SATURDAY', startTime:'17:00', endTime:'22:00', price:widget.court.pricePerHour * 1.6, priority:3, isActive:true, updatedAt:now),
      OwnerPricingRuleModel(id:'r5', courtId:widget.court.id, courtName:widget.court.name, name:'Khuyến mãi cũ', startTime:'06:00', endTime:'22:00', price:widget.court.pricePerHour * 0.8, priority:1, isActive:false, updatedAt:now),
    ];
  }

  List<OwnerPricingRuleModel> get _filtered => _showInactive ? _rules : _rules.where((r) => r.isActive).toList();
  int get _activeCount => _rules.where((r) => r.isActive).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: _brand,
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _showInactive = !_showInactive),
                child: Container(margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(_showInactive ? 'Ẩn tắt' : 'Hiện tắt', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
              ),
              IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white), onPressed: () => _showEditSheet(context, null)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SafeArea(child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Bảng Giá · ${widget.court.name}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    const Text('Quản Lý Khung Giờ', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    // Base price info
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        const Icon(Icons.info_outline_rounded, size: 14, color: Colors.white70),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Giá cơ bản: ${_fmtP(widget.court.pricePerHour)}/giờ (courts.price_per_hour — áp dụng khi không có rule phù hợp)', style: const TextStyle(color: Colors.white70, fontSize: 10))),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      _Chip('$_activeCount quy tắc đang dùng', AppColors.success),
                      const SizedBox(width: 8),
                      _Chip('${_rules.length - _activeCount} tắt', Colors.white60),
                    ]),
                  ]),
                )),
              ),
              title: Text('Bảng Giá · ${widget.court.name}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),

          // ── Priority legend ──
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.info.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.info.withOpacity(0.2))),
              child: const Row(children: [
                Icon(Icons.priority_high_rounded, size: 14, color: AppColors.info),
                SizedBox(width: 6),
                Expanded(child: Text('Ưu tiên cao hơn = áp dụng trước khi có nhiều rule cùng khung giờ. Giá cơ bản = ưu tiên 0.', style: TextStyle(fontSize: 10, color: AppColors.info))),
              ]),
            ),
          ),

          // ── Rules list ──
          _filtered.isEmpty
              ? const SliverFillRemaining(child: Center(child: Text('Chưa có quy tắc giá', style: TextStyle(color: AppColors.textHint))))
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _PricingRuleCard(
                        rule: _filtered[i],
                        basePrice: widget.court.pricePerHour,
                        onToggle: () => setState(() {
                          final idx = _rules.indexWhere((r) => r.id == _filtered[i].id);
                          if (idx >= 0) _rules[idx] = _rules[idx].copyWith(isActive: !_rules[idx].isActive);
                          HapticFeedback.selectionClick();
                        }),
                        onEdit: () => _showEditSheet(context, _filtered[i]),
                        onDelete: () => _confirmDelete(context, _filtered[i]),
                      ),
                      childCount: _filtered.length,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditSheet(context, null),
        backgroundColor: _brand,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Thêm Quy Tắc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showEditSheet(BuildContext context, OwnerPricingRuleModel? existing) {
    final isNew = existing == null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final priceCtrl = TextEditingController(text: existing != null ? existing.price.toInt().toString() : '');
    String? selectedDay = existing?.dayOfWeek;
    TimeOfDay startT = _toTOD(existing?.startTime ?? '06:00');
    TimeOfDay endT = _toTOD(existing?.endTime ?? '22:00');
    int priority = existing?.priority ?? 1;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [Icon(isNew ? Icons.add_circle_rounded : Icons.edit_rounded, color: _brand, size: 20), const SizedBox(width: 8), Text(isNew ? 'Thêm Quy Tắc Giá' : 'Sửa Quy Tắc', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 16),

            _Label('Tên quy tắc (tuỳ chọn)'),
            TextField(controller: nameCtrl, decoration: InputDecoration(hintText: 'VD: Giờ vàng tối', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
            const SizedBox(height: 12),

            _Label('Ngày áp dụng'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _DayChip(label: 'Tất cả ngày', selected: selectedDay == null, onTap: () => ss(() => selectedDay = null)),
                ...[['MONDAY','T2'],['TUESDAY','T3'],['WEDNESDAY','T4'],['THURSDAY','T5'],['FRIDAY','T6'],['SATURDAY','T7'],['SUNDAY','CN']]
                    .map((d) => _DayChip(label: d[1], selected: selectedDay == d[0], onTap: () => ss(() => selectedDay = d[0]),
                      highlight: d[0] == 'SATURDAY' || d[0] == 'SUNDAY')),
              ]),
            ),
            const SizedBox(height: 12),

            _Label('Khung giờ'),
            Row(children: [
              Expanded(child: _TimePicker(label: 'Từ', time: startT, onPick: (t) => ss(() => startT = t))),
              const SizedBox(width: 12),
              Expanded(child: _TimePicker(label: 'Đến', time: endT, onPick: (t) => ss(() => endT = t))),
            ]),
            const SizedBox(height: 12),

            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _Label('Giá / giờ (VNĐ)'),
                TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(prefixText: '₫ ', hintText: widget.court.pricePerHour.toInt().toString(), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
              ])),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _Label('Ưu tiên'),
                Row(children: List.generate(5, (i) => GestureDetector(
                  onTap: () => ss(() => priority = i + 1),
                  child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(right: 6), width: 32, height: 32,
                    decoration: BoxDecoration(color: priority == i+1 ? _brand : Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: priority == i+1 ? _brand : AppColors.borderLight)),
                    child: Center(child: Text('${i+1}', style: TextStyle(fontWeight: FontWeight.bold, color: priority == i+1 ? Colors.white : AppColors.textSecondary, fontSize: 12)))),
                ))),
              ]),
            ]),
            const SizedBox(height: 16),

            // Preview
            if (priceCtrl.text.isNotEmpty) ...[
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _brand.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.preview_rounded, size: 14, color: Color(0xFF0891B2)),
                  const SizedBox(width: 6),
                  Text('Preview: ${nameCtrl.text.isEmpty ? (selectedDay ?? "Tất cả ngày") : nameCtrl.text} · ${_todStr(startT)}–${_todStr(endT)} → ₫${priceCtrl.text}/giờ', style: const TextStyle(fontSize: 10, color: Color(0xFF0891B2), fontWeight: FontWeight.w600)),
                ])),
              const SizedBox(height: 12),
            ],

            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () {
                final p = double.tryParse(priceCtrl.text) ?? 0;
                if (p <= 0) return;
                Navigator.pop(ctx);
                setState(() {
                  if (isNew) {
                    _rules.add(OwnerPricingRuleModel(id:'r${_rules.length+1}', courtId:widget.court.id, courtName:widget.court.name, name:nameCtrl.text.isEmpty ? null : nameCtrl.text, dayOfWeek:selectedDay, startTime:_todStr(startT), endTime:_todStr(endT), price:p, priority:priority, isActive:true, updatedAt:DateTime.now()));
                  } else {
                    final idx = _rules.indexWhere((r) => r.id == existing.id);
                    if (idx >= 0) _rules[idx] = existing.copyWith(name: nameCtrl.text.isEmpty ? null : nameCtrl.text, price: p, priority: priority);
                  }
                });
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isNew ? '✅ Đã thêm quy tắc giá' : '✅ Đã cập nhật quy tắc'), backgroundColor: AppColors.success));
              },
              style: ElevatedButton.styleFrom(backgroundColor: _brand, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(isNew ? 'Thêm quy tắc' : 'Lưu thay đổi', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ])),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, OwnerPricingRuleModel rule) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xoá quy tắc?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Xoá "${rule.name ?? rule.dayLabel} · ${rule.startTime}–${rule.endTime}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); setState(() => _rules.removeWhere((r) => r.id == rule.id)); HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã xoá quy tắc giá'), backgroundColor: AppColors.success)); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Xoá', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  TimeOfDay _toTOD(String s) { final p = s.split(':'); return TimeOfDay(hour: int.tryParse(p[0]) ?? 0, minute: int.tryParse(p.length > 1 ? p[1] : '0') ?? 0); }
  String _todStr(TimeOfDay t) => '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
  String _fmtP(double v) { if (v >= 1000) return '${(v/1000).round()}K'; return v.toStringAsFixed(0); }
}

// ── Pricing Rule Card ─────────────────────────────────────────────────────────
class _PricingRuleCard extends StatelessWidget {
  final OwnerPricingRuleModel rule;
  final double basePrice;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _PricingRuleCard({required this.rule, required this.basePrice, required this.onToggle, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final multiplier = basePrice > 0 ? rule.price / basePrice : 1.0;
    final accentColor = !rule.isActive ? AppColors.textHint
        : rule.isPeakHour ? AppColors.warning
        : rule.isWeekend ? AppColors.success
        : brand;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: rule.isActive ? 1.0 : 0.55,
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: rule.isActive ? accentColor.withOpacity(0.25) : AppColors.borderLight),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
          ),
          child: Row(children: [
            Container(width: 4, height: 54, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (rule.name != null)
                  Expanded(child: Text(rule.name!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis))
                else
                  Expanded(child: Text('${rule.startTime}–${rule.endTime}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                if (rule.isPeakHour) _Tag('⚡ Cao điểm', AppColors.warning),
                if (rule.isWeekend) _Tag('🏖 Cuối tuần', AppColors.success),
              ]),
              const SizedBox(height: 3),
              Row(children: [
                Icon(Icons.access_time_rounded, size: 11, color: AppColors.textHint),
                const SizedBox(width: 3),
                Text('${rule.startTime} – ${rule.endTime}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Icon(Icons.calendar_today_rounded, size: 11, color: AppColors.textHint),
                const SizedBox(width: 3),
                Text(rule.dayLabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 2),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text('P${rule.priority}', style: TextStyle(fontSize: 9, color: accentColor, fontWeight: FontWeight.bold))),
                const SizedBox(width: 6),
                if (basePrice > 0) Text('×${multiplier.toStringAsFixed(1)} giá cơ bản', style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
              ]),
            ])),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(_fmtP(rule.price), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: accentColor)),
              const Text('/giờ', style: TextStyle(fontSize: 9, color: AppColors.textHint)),
              const SizedBox(height: 4),
              Row(mainAxisSize: MainAxisSize.min, children: [
                // Toggle
                GestureDetector(onTap: onToggle, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: rule.isActive ? accentColor.withOpacity(0.1) : AppColors.borderLight.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 5, height: 5, decoration: BoxDecoration(color: rule.isActive ? accentColor : AppColors.textHint, shape: BoxShape.circle)),
                    const SizedBox(width: 3),
                    Text(rule.isActive ? 'Bật' : 'Tắt', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: rule.isActive ? accentColor : AppColors.textHint)),
                  ]))),
                const SizedBox(width: 6),
                // Delete
                GestureDetector(onTap: onDelete, child: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error)),
              ]),
            ]),
          ]),
        ),
      ),
    );
  }

  String _fmtP(double v) { if (v >= 1000) return '${(v/1000).round()}K'; return v.toStringAsFixed(0); }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _Tag extends StatelessWidget {
  final String label; final Color color;
  const _Tag(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(left: 4), padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)));
}

class _Chip extends StatelessWidget {
  final String label; final Color color;
  const _Chip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)));
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)));
}

class _DayChip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap; final bool highlight;
  const _DayChip({required this.label, required this.selected, required this.onTap, this.highlight = false});
  static const Color _brand = Color(0xFF0891B2);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: selected ? _brand : (highlight ? AppColors.success.withOpacity(0.08) : Colors.white), borderRadius: BorderRadius.circular(8), border: Border.all(color: selected ? _brand : (highlight ? AppColors.success.withOpacity(0.4) : AppColors.borderLight))),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : (highlight ? AppColors.success : AppColors.textSecondary)))),
  );
}

class _TimePicker extends StatelessWidget {
  final String label; final TimeOfDay time; final void Function(TimeOfDay) onPick;
  const _TimePicker({required this.label, required this.time, required this.onPick});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async { final t = await showTimePicker(context: context, initialTime: time); if (t != null) onPick(t); },
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
        Text('${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ])])),
  );
}
