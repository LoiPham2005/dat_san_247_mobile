import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/data/models/owner_extended_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-07: Chính Sách Hoàn Tiền
// DB: refund_policies (venue_id), refund_rules (policy_id)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerRefundPolicyPage extends StatefulWidget {
  final String venueId;
  final String venueName;
  const OwnerRefundPolicyPage({super.key, required this.venueId, required this.venueName});
  @override
  State<OwnerRefundPolicyPage> createState() => _OwnerRefundPolicyPageState();
}

class _OwnerRefundPolicyPageState extends State<OwnerRefundPolicyPage> {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);
  List<RefundPolicyModel> _policies = _buildMock();

  static List<RefundPolicyModel> _buildMock() {
    final now = DateTime.now();
    return [
      RefundPolicyModel(id:'p1', venueId:'v1', name:'Chính sách tiêu chuẩn', description:'Áp dụng cho đặt sân thông thường.', isActive:true, isDefault:true, createdAt:now, updatedAt:now, rules:[
        const RefundRuleModel(id:'r1', policyId:'p1', cancelBeforeHours:48, refundPercentage:100, description:'Hoàn 100% nếu hủy trước 2 ngày'),
        const RefundRuleModel(id:'r2', policyId:'p1', cancelBeforeHours:24, refundPercentage:50, description:'Hoàn 50% nếu hủy trước 1 ngày'),
        const RefundRuleModel(id:'r3', policyId:'p1', cancelBeforeHours:2, refundPercentage:0, description:'Không hoàn nếu hủy trong vòng 2 giờ'),
      ]),
      RefundPolicyModel(id:'p2', venueId:'v1', name:'Chính sách cuối tuần', description:'Điều kiện chặt hơn cho T7, CN.', isActive:true, isDefault:false, createdAt:now, updatedAt:now, rules:[
        const RefundRuleModel(id:'r4', policyId:'p2', cancelBeforeHours:72, refundPercentage:100, description:'Hoàn 100% nếu hủy trước 3 ngày'),
        const RefundRuleModel(id:'r5', policyId:'p2', cancelBeforeHours:0, refundPercentage:0, description:'Không hoàn các trường hợp còn lại'),
      ]),
      RefundPolicyModel(id:'p3', venueId:'v1', name:'Không hoàn tiền', description:'Dùng cho khuyến mãi giảm sâu.', isActive:false, isDefault:false, createdAt:now, updatedAt:now, rules:[
        const RefundRuleModel(id:'r6', policyId:'p3', cancelBeforeHours:0, refundPercentage:0, description:'Không hoàn trong mọi trường hợp'),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true, expandedHeight: 140, backgroundColor: _brand,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
          actions: [IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white), onPressed: () => _showEditPolicySheet(context, null))],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 46, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.venueName, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                const Text('Chính Sách Hoàn Tiền', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(children: [
                  _Chip('${_policies.length} policy', Colors.white),
                  const SizedBox(width: 8),
                  _Chip('${_policies.where((p) => p.isActive).length} đang dùng', AppColors.success),
                ]),
              ]))),
            ),
            title: const Text('Chính Sách Hoàn Tiền', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
        SliverToBoxAdapter(child: Container(
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 0), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.info.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.info.withOpacity(0.3))),
          child: const Row(children: [Icon(Icons.info_outline_rounded, size: 14, color: AppColors.info), SizedBox(width: 8), Expanded(child: Text('Policy "Mặc định" áp dụng khi tạo booking mới nếu không chỉ định policy khác.', style: TextStyle(fontSize: 11, color: AppColors.info)))]),
        )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
          sliver: SliverList(delegate: SliverChildBuilderDelegate(
            (_, i) => _PolicyCard(
              policy: _policies[i],
              onEdit: () => _showEditPolicySheet(context, _policies[i]),
              onToggleDefault: () { setState(() { _policies = _policies.map((p) => p.copyWith(isDefault: p.id == _policies[i].id)).toList(); }); HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã đặt mặc định'), backgroundColor: AppColors.success)); },
              onToggleActive: () => setState(() { final p = _policies[i]; _policies[i] = p.copyWith(isActive: !p.isActive, isDefault: p.isDefault && p.isActive ? false : p.isDefault); }),
              onDelete: () => showDialog(context: context, builder: (ctx) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), title: const Text('Xoá policy?', style: TextStyle(fontWeight: FontWeight.bold)), content: Text('Xoá "${_policies[i].name}"?\nBooking đang dùng policy này có thể bị ảnh hưởng.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')), ElevatedButton(onPressed: () { Navigator.pop(ctx); setState(() => _policies.removeWhere((p) => p.id == _policies[i].id)); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Xoá', style: TextStyle(color: Colors.white)))])),
              onAddRule: () => _showEditRuleSheet(context, _policies[i], null),
              onDeleteRule: (ruleId) => setState(() { final rules = List<RefundRuleModel>.from(_policies[i].rules)..removeWhere((r) => r.id == ruleId); _policies[i] = _policies[i].copyWith(rules: rules); }),
            ),
            childCount: _policies.length,
          )),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showEditPolicySheet(context, null), backgroundColor: _brand, icon: const Icon(Icons.add_rounded, color: Colors.white), label: const Text('Thêm Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }

  void _showEditPolicySheet(BuildContext ctx2, RefundPolicyModel? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 14),
        Text(existing == null ? 'Tạo Policy Mới' : 'Sửa Policy', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Tên policy *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
        const SizedBox(height: 10),
        TextField(controller: descCtrl, maxLines: 2, decoration: InputDecoration(labelText: 'Mô tả', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () {
            if (nameCtrl.text.isEmpty) return; Navigator.pop(ctx);
            setState(() {
              if (existing == null) _policies.add(RefundPolicyModel(id:'p${_policies.length+1}', venueId:widget.venueId, name:nameCtrl.text, description:descCtrl.text.isEmpty ? null : descCtrl.text, rules:[], createdAt:DateTime.now(), updatedAt:DateTime.now()));
              else { final idx = _policies.indexWhere((p) => p.id == existing.id); if (idx >= 0) _policies[idx] = _policies[idx].copyWith(name: nameCtrl.text, description: descCtrl.text.isEmpty ? null : descCtrl.text); }
            });
            HapticFeedback.mediumImpact();
          },
          style: ElevatedButton.styleFrom(backgroundColor: _brand, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(existing == null ? 'Tạo Policy' : 'Lưu', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )),
      ]))),
    );
  }

  void _showEditRuleSheet(BuildContext ctx2, RefundPolicyModel policy, RefundRuleModel? existing) {
    final hoursCtrl = TextEditingController(text: existing?.cancelBeforeHours.toString() ?? '24');
    final pctCtrl = TextEditingController(text: existing?.refundPercentage.toStringAsFixed(0) ?? '100');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 14),
        Text(existing == null ? 'Thêm Mức Hoàn Tiền' : 'Sửa Mức Hoàn Tiền', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Policy: ${policy.name}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: TextField(controller: hoursCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Hủy trước (giờ)*', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))))),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: pctCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: '% hoàn tiền*', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), suffix: const Text('%')))),
        ]),
        const SizedBox(height: 10),
        TextField(controller: descCtrl, decoration: InputDecoration(labelText: 'Mô tả (hiển thị khách)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () {
            final h = int.tryParse(hoursCtrl.text) ?? 0; final pct = double.tryParse(pctCtrl.text) ?? 0;
            if (pct < 0 || pct > 100) return; Navigator.pop(ctx);
            setState(() {
              final pIdx = _policies.indexWhere((p) => p.id == policy.id);
              if (pIdx >= 0) {
                final rules = List<RefundRuleModel>.from(_policies[pIdx].rules);
                if (existing == null) rules.add(RefundRuleModel(id:'r${DateTime.now().millisecondsSinceEpoch}', policyId:policy.id, cancelBeforeHours:h, refundPercentage:pct, description:descCtrl.text.isEmpty ? null : descCtrl.text));
                else { final rIdx = rules.indexWhere((r) => r.id == existing.id); if (rIdx >= 0) rules[rIdx] = RefundRuleModel(id:existing.id, policyId:policy.id, cancelBeforeHours:h, refundPercentage:pct, description:descCtrl.text.isEmpty ? null : descCtrl.text); }
                _policies[pIdx] = _policies[pIdx].copyWith(rules: rules..sort((a,b) => b.cancelBeforeHours.compareTo(a.cancelBeforeHours)));
              }
            });
            HapticFeedback.mediumImpact();
          },
          style: ElevatedButton.styleFrom(backgroundColor: _brand, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(existing == null ? 'Thêm' : 'Lưu', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )),
      ]))),
    );
  }
}

class _PolicyCard extends StatefulWidget {
  final RefundPolicyModel policy;
  final VoidCallback onEdit, onToggleDefault, onToggleActive, onDelete, onAddRule;
  final void Function(String) onDeleteRule;
  const _PolicyCard({required this.policy, required this.onEdit, required this.onToggleDefault, required this.onToggleActive, required this.onDelete, required this.onAddRule, required this.onDeleteRule});
  @override
  State<_PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<_PolicyCard> {
  bool _expanded = true;
  @override
  Widget build(BuildContext context) {
    final p = widget.policy;
    const brand = Color(0xFF0891B2);
    return AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: p.isActive ? 1.0 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.isDefault ? AppColors.success.withOpacity(0.4) : AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Column(children: [
          GestureDetector(onTap: () => setState(() => _expanded = !_expanded), child: Padding(padding: const EdgeInsets.fromLTRB(14, 12, 10, 10), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.policy_rounded, color: Color(0xFF0891B2), size: 18)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900))),
                if (p.isDefault) Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Text('Mặc định', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success))),
                if (!p.isActive) Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(20)), child: const Text('Tắt', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textHint))),
              ]),
              if (p.description != null) Text(p.description!, style: const TextStyle(fontSize: 10, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
            Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: AppColors.textHint),
          ]))),
          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            ...p.rules.map((r) {
              final color = r.refundPercentage >= 80 ? AppColors.success : r.refundPercentage >= 30 ? AppColors.warning : AppColors.error;
              return Padding(padding: const EdgeInsets.fromLTRB(14, 8, 14, 0), child: Row(children: [
                Container(width: 46, height: 46, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('${r.refundPercentage.toStringAsFixed(0)}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)), Text('hoàn', style: TextStyle(fontSize: 8, color: color))])),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.cancelBeforeHours >= 24 ? 'Hủy trước ${r.cancelBeforeHours ~/ 24} ngày' : r.cancelBeforeHours > 0 ? 'Hủy trước ${r.cancelBeforeHours}h' : 'Các trường hợp còn lại', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  if (r.description != null) Text(r.description!, style: const TextStyle(fontSize: 10, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                IconButton(icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error), onPressed: () => widget.onDeleteRule(r.id), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              ]));
            }),
            Padding(padding: const EdgeInsets.all(10), child: GestureDetector(onTap: widget.onAddRule,
              child: Container(padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: brand.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: brand.withOpacity(0.2))),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_rounded, size: 14, color: Color(0xFF0891B2)), SizedBox(width: 4), Text('Thêm mức hoàn tiền', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))])))),
          ],
          const Divider(height: 1, color: AppColors.borderLight),
          Padding(padding: const EdgeInsets.fromLTRB(10, 6, 10, 10), child: Row(children: [
            _Btn(Icons.edit_rounded, 'Sửa', brand, widget.onEdit),
            const SizedBox(width: 6),
            if (!p.isDefault) _Btn(Icons.star_rounded, 'Đặt mặc định', AppColors.success, widget.onToggleDefault),
            if (!p.isDefault) const SizedBox(width: 6),
            _Btn(p.isActive ? Icons.visibility_off_rounded : Icons.visibility_rounded, p.isActive ? 'Tắt' : 'Bật', p.isActive ? AppColors.textHint : AppColors.success, widget.onToggleActive),
            const Spacer(),
            if (!p.isDefault) _Btn(Icons.delete_outline_rounded, 'Xoá', AppColors.error, widget.onDelete),
          ])),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label; final Color color; const _Chip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)));
}

class _Btn extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _Btn(this.icon, this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () { HapticFeedback.selectionClick(); onTap(); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color), const SizedBox(width: 3), Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))])));
}
