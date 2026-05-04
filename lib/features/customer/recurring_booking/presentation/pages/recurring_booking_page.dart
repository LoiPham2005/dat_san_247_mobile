import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/presentation/providers/recurring_booking_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/recurring_booking_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-13: Lịch Định Kỳ
// ──────────────────────────────────────────────────────────────────────────
class RecurringBookingPage extends HookConsumerWidget {
  const RecurringBookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final selectedTab = useState(0);

    useEffect(() {
      void listener() {
        if (tabController.indexIsChanging) {
          selectedTab.value = tabController.index;
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    final state = ref.watch(recurringBookingProvider);
    final notifier = ref.read(recurringBookingProvider.notifier);

    useAsyncValueListener(provider: recurringBookingProvider, ref: ref);

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
          'Lịch đặt định kỳ',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.primaryLightBrand,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primaryLightBrand,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: const [Tab(text: 'Đang hoạt động'), Tab(text: 'Đã dừng')],
          ),
        ),
      ),
      body: switch (state) {
        AsyncData(:final value) => () {
            final filtered = value
                .where((r) => selectedTab.value == 0 ? r.isActive : !r.isActive)
                .toList();
            return filtered.isEmpty
                ? _buildEmpty()
                : _buildList(context, notifier, filtered);
          }(),
        AsyncError(:final error) => Center(child: Text('$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    RecurringBookingNotifier notifier,
    List<RecurringBookingModel> filtered,
  ) {
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (ctx, i) => RecurringBookingCard(
          item: filtered[i],
          onToggle: (item) => _toggleActive(context, notifier, item),
        ),
      ),
    );
  }

  Future<void> _toggleActive(
    BuildContext context,
    RecurringBookingNotifier notifier,
    RecurringBookingModel item,
  ) async {
    final action = item.isActive ? 'tạm dừng' : 'kích hoạt lại';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('${item.isActive ? 'Tạm dừng' : 'Kích hoạt'} lịch định kỳ?'),
        content: Text(
            'Bạn muốn $action lịch đặt "${item.courtName}" tại "${item.venueName}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  item.isActive ? AppColors.error : AppColors.primaryLightBrand,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              item.isActive ? 'Tạm dừng' : 'Kích hoạt',
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.toggleStatus(item.id, item.isActive);
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
                color: AppColors.primaryLightBrand.withOpacity(0.08),
                shape: BoxShape.circle),
            child: const Icon(Icons.repeat_rounded,
                size: 44, color: AppColors.primaryLightBrand),
          ),
          const SizedBox(height: 16),
          const Text('Chưa có lịch định kỳ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            'Lịch định kỳ được tạo khi bạn đặt sân hằng tuần',
            style: TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
