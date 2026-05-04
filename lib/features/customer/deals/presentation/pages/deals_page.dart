import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/providers/deals_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/deals_app_bar.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/deals_category_filter.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/deals_promo_banner.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/voucher_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DealsPage extends HookConsumerWidget {
  const DealsPage({super.key});

  static const _categories = ['Tất cả', 'Voucher sân', 'Cầu lông', 'Bóng đá', 'Ưu đãi hot'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryIndex = useState(0);
    final state = ref.watch(dealsProvider);
    final notifier = ref.read(dealsProvider.notifier);

    useAsyncValueListener(provider: dealsProvider, ref: ref);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            const DealsAppBar(),
            const DealsPromoBanner(),
            DealsCategoryFilter(
              selectedIndex: selectedCategoryIndex.value,
              categories: _categories,
              onCategoryChanged: (i) => selectedCategoryIndex.value = i,
            ),
            switch (state) {
              AsyncData(:final value) when value.data.isEmpty =>
                const SliverFillRemaining(
                  child: Center(child: Text('Hiện chưa có chương trình ưu đãi nào')),
                ),
              AsyncData(:final value) => SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => VoucherCard(promotion: value.data[index]),
                      childCount: value.data.length,
                    ),
                  ),
                ),
              AsyncError(:final error) => SliverFillRemaining(
                  child: Center(child: Text('Lỗi tải khuyến mãi: $error')),
                ),
              _ => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
            },
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
