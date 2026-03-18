import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-14: Waitlist Của Tôi
// ──────────────────────────────────────────────────────────────────────────
class MyWaitlistPage extends StatefulWidget {
  const MyWaitlistPage({super.key});

  @override
  State<MyWaitlistPage> createState() => _MyWaitlistPageState();
}

class _MyWaitlistPageState extends State<MyWaitlistPage> {
  final List<WaitlistItemModel> _mockData = [
    WaitlistItemModel(
      id: 'w1',
      courtId: 'c1',
      courtName: 'Sân A - 5 người',
      venueId: 'v1',
      venueName: 'Sân K34 Phạm Văn Đồng',
      venueAddress: 'Số 10 Phạm Văn Đồng, Cầu Giấy, Hà Nội',
      venueThumbnailUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbc09e99c?w=400&q=80',
      bookingDate: DateTime.now().add(const Duration(days: 3)),
      startTime: '19:00',
      endTime: '20:00',
      priority: 2,
      isNotified: false,
      status: WaitlistStatus.WAITING,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    WaitlistItemModel(
      id: 'w2',
      courtId: 'c2',
      courtName: 'Sân Cầu Lông B',
      venueId: 'v2',
      venueName: 'Sân Thể Thao Vạn Hạnh',
      venueAddress: '45 Điện Biên Phủ, Bình Thạnh, TP.HCM',
      bookingDate: DateTime.now().add(const Duration(days: 1)),
      startTime: '07:00',
      endTime: '08:00',
      priority: 1,
      isNotified: true,
      status: WaitlistStatus.WAITING,
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    WaitlistItemModel(
      id: 'w3',
      courtId: 'c3',
      courtName: 'Sân Pickleball 1',
      venueId: 'v2',
      venueName: 'Sân Thể Thao Vạn Hạnh',
      venueAddress: '45 Điện Biên Phủ, Bình Thạnh, TP.HCM',
      bookingDate: DateTime.now().subtract(const Duration(days: 2)),
      startTime: '15:00',
      endTime: '16:00',
      priority: 3,
      isNotified: true,
      status: WaitlistStatus.CONVERTED,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    WaitlistItemModel(
      id: 'w4',
      courtId: 'c1',
      courtName: 'Sân A - 5 người',
      venueId: 'v1',
      venueName: 'Sân K34 Phạm Văn Đồng',
      venueAddress: 'Số 10 Phạm Văn Đồng, Cầu Giấy, Hà Nội',
      bookingDate: DateTime.now().subtract(const Duration(days: 5)),
      startTime: '18:00',
      endTime: '19:00',
      priority: 1,
      isNotified: false,
      status: WaitlistStatus.EXPIRED,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  Future<void> _cancelWaitlist(WaitlistItemModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hủy khỏi danh sách chờ?'),
        content: Text('Bạn sẽ mất vị trí #${item.priority} trong danh sách chờ của "${item.courtName}".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Giữ lại')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Hủy chờ', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        final idx = _mockData.indexOf(item);
        _mockData[idx] = WaitlistItemModel(
          id: item.id, courtId: item.courtId, courtName: item.courtName,
          venueId: item.venueId, venueName: item.venueName, venueAddress: item.venueAddress,
          venueThumbnailUrl: item.venueThumbnailUrl, bookingDate: item.bookingDate,
          startTime: item.startTime, endTime: item.endTime, priority: item.priority,
          isNotified: item.isNotified, status: WaitlistStatus.CANCELLED, createdAt: item.createdAt,
        );
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã hủy khỏi danh sách chờ'), backgroundColor: AppColors.primaryLightBrand));
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeList = _mockData.where((w) => w.status == WaitlistStatus.WAITING).toList();
    final historyList = _mockData.where((w) => w.status != WaitlistStatus.WAITING).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Danh sách chờ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: _mockData.isEmpty
          ? _buildEmpty()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Info Banner ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.info.withOpacity(0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bạn sẽ nhận thông báo khi có slot trống. Thứ tự ưu tiên càng thấp → được thông báo trước.',
                            style: TextStyle(fontSize: 12, color: AppColors.info),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Active waiting ──
                  if (activeList.isNotEmpty) ...[
                    _SectionLabel(label: '⏳ Đang chờ (${activeList.length})'),
                    const SizedBox(height: 10),
                    ...activeList.map((w) => _WaitlistCard(item: w, onCancel: () => _cancelWaitlist(w))),
                    const SizedBox(height: 16),
                  ],

                  // ── History ──
                  if (historyList.isNotEmpty) ...[
                    _SectionLabel(label: 'Lịch sử'),
                    const SizedBox(height: 10),
                    ...historyList.map((w) => _WaitlistCard(item: w, onCancel: null)),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.queue_rounded, size: 64, color: AppColors.primaryLightBrand),
          SizedBox(height: 16),
          Text('Danh sách chờ trống', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('Đăng ký chờ khi sân đầy để không bỏ lỡ slot', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary));
}

class _WaitlistCard extends StatelessWidget {
  final WaitlistItemModel item;
  final VoidCallback? onCancel;
  const _WaitlistCard({required this.item, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEE, dd/MM', 'vi_VN');
    final (statusColor, statusBg, statusLabel) = _statusStyle(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority badge
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: item.status == WaitlistStatus.WAITING ? AppColors.primaryLightBrand : AppColors.mutedLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('#${item.priority}', style: TextStyle(
                      color: item.status == WaitlistStatus.WAITING ? AppColors.white : AppColors.textHint,
                      fontWeight: FontWeight.w900, fontSize: 13,
                    )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.venueName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(item.courtName, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _Chip(icon: Icons.event_rounded, label: dateFmt.format(item.bookingDate)),
                          const SizedBox(width: 6),
                          _Chip(icon: Icons.access_time_rounded, label: '${item.startTime}–${item.endTime}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                      child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                    ),
                    if (item.isNotified) ...[
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_active_rounded, size: 12, color: AppColors.primaryLightBrand),
                          SizedBox(width: 2),
                          Text('Đã thông báo', style: TextStyle(fontSize: 10, color: AppColors.primaryLightBrand)),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (onCancel != null) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            TextButton(
              onPressed: onCancel,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_circle_outline_rounded, size: 15, color: AppColors.error),
                  SizedBox(width: 4),
                  Text('Hủy khỏi danh sách chờ', style: TextStyle(color: AppColors.error, fontSize: 13)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  (Color, Color, String) _statusStyle(WaitlistStatus s) {
    switch (s) {
      case WaitlistStatus.WAITING: return (AppColors.warning, AppColors.warning.withOpacity(0.12), '⏳ Đang chờ');
      case WaitlistStatus.CONVERTED: return (AppColors.success, AppColors.success.withOpacity(0.1), '✅ Đã đặt');
      case WaitlistStatus.EXPIRED: return (AppColors.textHint, AppColors.mutedLight, '⌛ Hết hạn');
      case WaitlistStatus.CANCELLED: return (AppColors.error, AppColors.error.withOpacity(0.08), '❌ Đã hủy');
    }
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 11, color: AppColors.textHint),
      const SizedBox(width: 3),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    ],
  );
}
