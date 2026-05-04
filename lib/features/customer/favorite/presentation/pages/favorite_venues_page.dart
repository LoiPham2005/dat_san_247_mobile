import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/presentation/providers/favorite_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/favorite_venue_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-18: Venue Yêu Thích
// ──────────────────────────────────────────────────────────────────────────
class FavoriteVenuesPage extends ConsumerWidget {
  const FavoriteVenuesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteProvider);
    final notifier = ref.read(favoriteProvider.notifier);

    RiverpodListeners.async$(
      ref: ref,
      context: context,
      provider: favoriteProvider,
      notifier: notifier,
    );

    final count = state.value?.length ?? 0;

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
        title: Text(
          count == 0 ? 'Sân yêu thích' : 'Sân yêu thích ($count)',
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
      ),
      body: switch (state) {
        AsyncData(:final value) when value.isEmpty => _buildEmpty(context),
        AsyncData(:final value) => _buildList(context, notifier, value),
        AsyncError(:final error) => Center(child: Text('Lỗi: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    FavoriteNotifier notifier,
    List<FavoriteVenueModel> favorites,
  ) {
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (ctx, i) {
          final fav = favorites[i];
          return Dismissible(
            key: Key(fav.venueId),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(16)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      color: AppColors.white, size: 24),
                  SizedBox(height: 4),
                  Text('Bỏ YT',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            confirmDismiss: (_) =>
                _confirmRemove(context, notifier, fav).then((_) => false),
            child: FavoriteVenueCard(
              fav: fav,
              onRemove: () => _confirmRemove(context, notifier, fav),
              onBook: () => context.push('/venue-detail/${fav.venue.slug}'),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    FavoriteNotifier notifier,
    FavoriteVenueModel fav,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Bỏ yêu thích?'),
        content: Text('Bỏ "${fav.venue.name}" khỏi danh sách yêu thích?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text('Bỏ yêu thích',
                style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.toggleFavorite(fav.venueId);
      toast.success('💔 Đã bỏ khỏi yêu thích');
    }
  }

  Widget _buildEmpty(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border_rounded,
                  size: 44, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            const Text('Chưa có sân yêu thích',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Nhấn ❤️ khi xem chi tiết sân để lưu vào đây',
              style: TextStyle(color: AppColors.textHint, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/main'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBrand,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text(
                'Khám phá sân ngay',
                style: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
}
