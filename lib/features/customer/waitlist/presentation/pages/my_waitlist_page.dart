import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/models/waitlist_model.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/presentation/providers/waitlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/waitlist_card.dart';

class MyWaitlistPage extends ConsumerWidget {
  const MyWaitlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waitlistProvider);
    final notifier = ref.read(waitlistProvider.notifier);

    useAsyncValueListener(provider: waitlistProvider, ref: ref);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Danh sách chờ',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
      ),
      body: switch (state) {
        AsyncData(:final value) when value.isEmpty => _buildEmpty(context, notifier),
        AsyncData(:final value) => _buildContent(context, notifier, value),
        AsyncError(:final error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text('$error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: notifier.refresh,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    WaitlistNotifier notifier,
    List<WaitlistModel> list,
  ) {
    final activeList = list
        .where((w) =>
            w.status == WaitlistStatus.WAITING ||
            w.status == WaitlistStatus.NOTIFIED)
        .toList();
    final historyList = list
        .where((w) =>
            w.status != WaitlistStatus.WAITING &&
            w.status != WaitlistStatus.NOTIFIED)
        .toList();

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBanner(),
            const SizedBox(height: 16),
            if (activeList.isNotEmpty) ...[
              _SectionLabel(label: '⏳ Đang chờ (${activeList.length})'),
              const SizedBox(height: 10),
              ...activeList.map((w) => WaitlistCard(
                    item: w,
                    onCancel: () => _cancelWaitlist(context, notifier, w),
                  )),
              const SizedBox(height: 16),
            ],
            if (historyList.isNotEmpty) ...[
              const _SectionLabel(label: 'Lịch sử'),
              const SizedBox(height: 10),
              ...historyList.map((w) => WaitlistCard(item: w, onCancel: null)),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _cancelWaitlist(
    BuildContext context,
    WaitlistNotifier notifier,
    WaitlistModel item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hủy khỏi danh sách chờ?'),
        content: Text(
            'Bạn sẽ mất vị trí #${item.priority} trong danh sách chờ của "${item.courtName}".'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Giữ lại')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Hủy chờ', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await notifier.cancelWaitlist(item.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('✅ Đã gửi yêu cầu hủy danh sách chờ'),
            backgroundColor: AppColors.primaryLightBrand));
      }
    }
  }

  Widget _buildInfoBanner() {
    return Container(
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
    );
  }

  Widget _buildEmpty(BuildContext context, WaitlistNotifier notifier) {
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.queue_rounded,
                    size: 64, color: AppColors.primaryLightBrand),
                SizedBox(height: 16),
                Text('Danh sách chờ trống',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                  'Đăng ký chờ khi sân đầy để không bỏ lỡ slot',
                  style: TextStyle(color: AppColors.textHint, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary));
}
