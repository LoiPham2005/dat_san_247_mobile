import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-21: Bottom Sheet Báo Cáo Vi Phạm
// Dùng showReportSheet(context, targetType, targetId) từ bất kỳ trang nào
// ──────────────────────────────────────────────────────────────────────────
Future<void> showReportSheet(
  BuildContext context, {
  required ReportTargetType targetType,
  required String targetId,
  String? targetName,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReportBottomSheet(
      targetType: targetType,
      targetId: targetId,
      targetName: targetName,
    ),
  );
}

class _ReportBottomSheet extends StatefulWidget {
  final ReportTargetType targetType;
  final String targetId;
  final String? targetName;
  const _ReportBottomSheet({
    required this.targetType,
    required this.targetId,
    this.targetName,
  });

  @override
  State<_ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<_ReportBottomSheet> {
  ReportReason? _selectedReason;
  final _descCtrl = TextEditingController();
  bool _submitting = false;

  List<ReportReason> get _availableReasons {
    // TRANSACTION chỉ hiển thị DISPUTE_TRANSACTION
    if (widget.targetType == ReportTargetType.TRANSACTION) {
      return [ReportReason.DISPUTE_TRANSACTION, ReportReason.FRAUD, ReportReason.OTHER];
    }
    return ReportReason.values;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn lý do báo cáo'), backgroundColor: AppColors.error, duration: Duration(seconds: 2)));
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800)); // simulate API
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Báo cáo đã được ghi nhận. Cảm ơn bạn!'), backgroundColor: AppColors.primaryLightBrand, duration: Duration(seconds: 3)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ──
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),

          // ── Header ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.flag_rounded, color: AppColors.error, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Báo cáo ${widget.targetType.label}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  if (widget.targetName != null)
                    Text(widget.targetName!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Reasons ──
          const Text('Lý do báo cáo *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          ..._availableReasons.map((reason) => _ReasonTile(
            reason: reason,
            selected: _selectedReason == reason,
            onTap: () => setState(() => _selectedReason = reason),
          )),
          const SizedBox(height: 16),

          // ── Description ──
          const Text('Mô tả thêm (tuỳ chọn)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          TextField(
            controller: _descCtrl,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Mô tả chi tiết để chúng tôi xử lý nhanh hơn...',
              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
              filled: true, fillColor: AppColors.mutedLight,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              counterStyle: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 4),
          // ── Disclaimer ──
          const Text(
            'Báo cáo sai có thể ảnh hưởng đến tài khoản của bạn. Chỉ báo cáo khi thực sự có vi phạm.',
            style: TextStyle(fontSize: 11, color: AppColors.textHint, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),

          // ── Submit ──
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderLight),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Huỷ', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error, elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _submitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                    : const Text('Gửi báo cáo', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final ReportReason reason;
  final bool selected;
  final VoidCallback onTap;
  const _ReasonTile({required this.reason, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: selected ? AppColors.error.withOpacity(0.05) : AppColors.mutedLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? AppColors.error : AppColors.borderLight, width: selected ? 1.5 : 1),
      ),
      child: Row(children: [
        Expanded(child: Text(reason.label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? AppColors.error : AppColors.textPrimary))),
        if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.error, size: 18),
      ]),
    ),
  );
}
