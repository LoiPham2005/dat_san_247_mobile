import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/providers/owner_verification_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-13: Xác Minh Venue
// ══════════════════════════════════════════════════════════════════════════════
class OwnerVerificationPage extends HookConsumerWidget {
  final String venueId;
  final String venueName;
  const OwnerVerificationPage(
      {super.key, required this.venueId, required this.venueName});

  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showForm = useState(false);
    final provider = ownerVerificationProvider(venueId);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    useAsyncValueListener(provider: provider, ref: ref);

    final data = state.value;
    final ver = data?.verification;
    final filePaths = data?.filePaths ?? {};
    final isSubmitting = data?.isSubmitting ?? false;
    final allFilesSelected =
        filePaths.length == 4 && filePaths.values.every((v) => v != null);

    if (state.isLoading && data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: CustomScrollView(slivers: [
            // ── AppBar ──
            SliverAppBar(
              pinned: true, expandedHeight: 130, backgroundColor: _brand,
              title: const Text('Xác Minh', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),  
              titleSpacing: 0,
              leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 46, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(venueName, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                    // const Text('Xác Minh Venue', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    if (ver != null)
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)), child: Text('${ver.status.emoji} ${ver.status.label} • Phiên bản ${ver.version}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))
                    else
                      const Text('Chưa nộp hồ sơ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ]))),
                ),
              ),
            ),

            SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
              // ── Status card ──
              if (ver != null) _StatusCard(ver: ver),
              const SizedBox(height: 12),

              // ── Benefits card (if not verified) ──
              if (ver == null || !ver.isApproved) _BenefitsCard(),
              if (ver == null || !ver.isApproved) const SizedBox(height: 12),

              // ── Upload form toggle ──
              if (ver == null || ver.canResubmit || (ver.isPending && !showForm.value)) ...[
                if (ver?.isPending == true)
                  _InfoBox(Icons.hourglass_top_rounded, AppColors.warning, 'Hồ sơ đang được xét duyệt', 'Vui lòng chờ 1-3 ngày làm việc. Bạn sẽ nhận thông báo khi có kết quả.')
                else if (ver == null || ver.canResubmit)
                  GestureDetector(
                    onTap: () { HapticFeedback.selectionClick(); showForm.value = true; },
                    child: Container(
                      width: double.infinity, padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [_brand.withValues(alpha: 0.05), _brand.withValues(alpha: 0.12)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: _brand.withValues(alpha: 0.3))),
                      child: Row(children: [
                        Container(width: 44, height: 44, decoration: BoxDecoration(color: _brand.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.upload_file_rounded, color: Color(0xFF0891B2), size: 22)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(ver == null ? 'Nộp Hồ Sơ Xác Minh' : 'Nộp Lại Hồ Sơ (V${(ver.version) + 1})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0891B2))),
                          const Text('Chuẩn bị giấy tờ để bắt đầu', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                        ])),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF0891B2)),
                      ]),
                    ),
                  ),
              ],

              // ── Upload form ──
              if (showForm.value) ...[
                const SizedBox(height: 4),
                _UploadFormCard(
                  filePaths: filePaths,
                  onFileChanged: notifier.updateFilePath,
                  onCancel: () => showForm.value = false,
                  onSubmit: allFilesSelected ? notifier.submitVerification : null,
                  isSubmitting: isSubmitting,
                ),
              ],

              if (ver?.isApproved == true) ...[
                _InfoBox(Icons.verified_rounded, AppColors.success, 'Venue đã được xác minh!', 'Hồ sơ của bạn đã được phê duyệt. Venue sẽ hiển thị badge xác minh.'),
              ],

              const SizedBox(height: 30),
              // Steps guide
              _StepsCard(),
            ]))),
          ]),
        );
  }
}

// ── Status Card ───────────────────────────────────────────────────────────────
class _StatusCard extends StatelessWidget {
  final VenueVerificationModel ver;
  const _StatusCard({required this.ver});
  @override
  Widget build(BuildContext context) {
    final statusColor = switch (ver.status) {
      VerificationStatus.PENDING => AppColors.warning,
      VerificationStatus.APPROVED => AppColors.success,
      VerificationStatus.REJECTED => AppColors.error,
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.08), blurRadius: 12)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(ver.status.emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ver.status.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: statusColor)),
            Text('Hồ sơ phiên bản ${ver.version} • ${ver.createdAt != null ? DateFormat('dd/MM/yyyy').format(ver.createdAt!) : "Chưa xác định"}', style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
          ])),
        ]),
        if (ver.isRejected && ver.rejectionReason != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.error.withValues(alpha: 0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.info_outline_rounded, size: 13, color: AppColors.error), SizedBox(width: 6), Text('Lý do từ chối:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.error))]),
              const SizedBox(height: 4),
              Text(ver.rejectionReason!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
          ),
        ],
        if (ver.isApproved && ver.verifiedAt != null) ...[
          const SizedBox(height: 8),
          Row(children: [const Icon(Icons.check_circle_rounded, size: 13, color: AppColors.success), const SizedBox(width: 6), Text('Xác minh lúc ${DateFormat('dd/MM/yyyy HH:mm').format(ver.verifiedAt!)}', style: const TextStyle(fontSize: 11, color: AppColors.success))]),
        ],
      ]),
    );
  }
}

// ── Upload Form ───────────────────────────────────────────────────────────────
class _UploadFormCard extends StatelessWidget {
  final Map<String, String?> filePaths;
  final void Function(String key, String? path) onFileChanged;
  final VoidCallback onCancel;
  final VoidCallback? onSubmit;
  final bool isSubmitting;

  const _UploadFormCard({
    required this.filePaths, required this.onFileChanged,
    required this.onCancel, required this.onSubmit, required this.isSubmitting,
  });

  static const _docs = {
    'business_license': ('📋', 'Giấy Phép Kinh Doanh', 'Scan/ảnh chụp GP KD còn hiệu lực'),
    'id_card_front': ('🪪', 'CMND/CCCD Mặt Trước', 'Ảnh rõ nét, đủ 4 góc'),
    'id_card_back': ('🪪', 'CMND/CCCD Mặt Sau', 'Ảnh rõ nét, đủ 4 góc'),
    'owner_photo': ('🤳', 'Hình Chủ Sân Cầm CMND', 'Ảnh selfie cầm CMND/CCCD'),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.upload_file_rounded, size: 15, color: Color(0xFF0891B2)), SizedBox(width: 6), Text('Tải Lên Hồ Sơ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))]),
        const SizedBox(height: 4),
        const Text('Ảnh rõ ràng, không bị mờ hoặc che khuất. Chấp nhận JPG/PNG/PDF, tối đa 10MB mỗi file.', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
        const Divider(height: 16, color: AppColors.borderLight),

        ..._docs.entries.map((e) {
          final key = e.key;
          final (emoji, title, hint) = e.value;
          final uploaded = filePaths[key] != null;
          return GestureDetector(
            onTap: () => _pickFile(context, key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: uploaded ? AppColors.success.withValues(alpha: 0.04) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: uploaded ? AppColors.success.withOpacity(0.4) : AppColors.borderLight),
              ),
              child: Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: (uploaded ? AppColors.success : AppColors.textHint).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Center(child: uploaded ? const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22) : Text(emoji, style: const TextStyle(fontSize: 18)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: uploaded ? AppColors.success : AppColors.textPrimary)),
                  Text(uploaded ? '✓ Đã tải lên' : hint, style: TextStyle(fontSize: 10, color: uploaded ? AppColors.success : AppColors.textHint)),
                ])),
                Icon(uploaded ? Icons.edit_rounded : Icons.add_photo_alternate_rounded, size: 16, color: uploaded ? AppColors.success : AppColors.textHint),
              ]),
            ),
          );
        }),

        const SizedBox(height: 6),
        // Progress
        Row(children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
            value: filePaths.values.where((v) => v != null).length / 4,
            backgroundColor: AppColors.borderLight, color: const Color(0xFF0891B2), minHeight: 6,
          ))),
          const SizedBox(width: 10),
          Text('${filePaths.values.where((v) => v != null).length}/4', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0891B2))),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: onCancel, style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.borderLight), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Huỷ'))),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(backgroundColor: onSubmit != null ? const Color(0xFF0891B2) : AppColors.textHint, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: isSubmitting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Gửi Hồ Sơ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ]),
      ]),
    );
  }

  void _pickFile(BuildContext context, String key) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 12),
        const Text('Chọn nguồn ảnh', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.camera_alt_rounded, color: Color(0xFF0891B2)),
          title: const Text('Chụp ảnh'),
          onTap: () async {
            Navigator.pop(ctx);
            final file = await ImagePicker().pickImage(source: ImageSource.camera);
            if (file != null) onFileChanged(key, file.path);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF0891B2)),
          title: const Text('Chọn từ thư viện'),
          onTap: () async {
            Navigator.pop(ctx);
            final file = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (file != null) onFileChanged(key, file.path);
          },
        ),
        ListTile(
          leading: const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF0891B2)),
          title: const Text('Chọn tệp tin'),
          onTap: () async {
            Navigator.pop(ctx);
            final file = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (file != null) onFileChanged(key, file.path);
          },
        ),
        const SizedBox(height: 8),
      ])),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _BenefitsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Icon(Icons.verified_rounded, size: 14, color: Color(0xFF0891B2)), SizedBox(width: 6), Text('Lợi ích sau khi xác minh', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))]),
      const SizedBox(height: 10),
      ...[
        ('✅', 'Badge "Đã xác minh" trên trang venue'),
        ('🔝', 'Ưu tiên hiển thị trong kết quả tìm kiếm'),
        ('💎', 'Giới hạn rút tiền cao hơn (50M/tháng)'),
        ('📊', 'Truy cập dashboard báo cáo nâng cao'),
      ].map((b) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [Text(b.$1, style: const TextStyle(fontSize: 12)), const SizedBox(width: 8), Expanded(child: Text(b.$2, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)))]))),
    ]),
  );
}

class _StepsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Icon(Icons.list_alt_rounded, size: 14, color: AppColors.textHint), SizedBox(width: 6), Text('Quy trình xác minh', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textHint))]),
      const SizedBox(height: 10),
      ...[
        ('1', 'Nộp hồ sơ', 'Tải lên 4 loại giấy tờ yêu cầu', AppColors.info),
        ('2', 'Xét duyệt', 'Admin kiểm tra trong 1-3 ngày làm việc', AppColors.warning),
        ('3', 'Kết quả', 'Thông báo qua app & email', AppColors.success),
      ].map((s) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 22, height: 22, decoration: BoxDecoration(color: (s.$4).withValues(alpha: 0.1), shape: BoxShape.circle), child: Center(child: Text(s.$1, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: s.$4)))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.$2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text(s.$3, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ])),
      ]))),
    ]),
  );
}

class _InfoBox extends StatelessWidget {
  final IconData icon; final Color color; final String title, body;
  const _InfoBox(this.icon, this.color, this.title, this.body);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.25))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(body, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ])),
    ]),
  );
}
