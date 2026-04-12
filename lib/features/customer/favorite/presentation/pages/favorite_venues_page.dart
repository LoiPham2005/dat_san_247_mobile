import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../widgets/favorite_venue_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-18: Venue Yêu Thích
// ──────────────────────────────────────────────────────────────────────────
class FavoriteVenuesPage extends StatefulWidget {
  const FavoriteVenuesPage({super.key});

  @override
  State<FavoriteVenuesPage> createState() => _FavoriteVenuesPageState();
}

class _FavoriteVenuesPageState extends State<FavoriteVenuesPage> {
  Future<void> _removeFavorite(FavoriteVenueModel fav) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Bỏ yêu thích?'),
        content: Text('Bỏ "${fav.venue.name}" khỏi danh sách yêu thích?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Bỏ yêu thích', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<FavoriteCubit>().toggleFavorite(fav.venueId);
      toast.success('💔 Đã bỏ khỏi yêu thích');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: BlocBuilder<FavoriteCubit, BaseState<List<FavoriteVenueModel>>>(
          builder: (context, state) {
            final count = state.data?.length ?? 0;
            return Text(
              count == 0 ? 'Sân yêu thích' : 'Sân yêu thích ($count)',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            );
          },
        ),
      ),
      body: BlocBuilder<FavoriteCubit, BaseState<List<FavoriteVenueModel>>>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: (previousData) => previousData == null 
                ? const Center(child: CircularProgressIndicator()) 
                : _buildList(previousData),
            success: (data, message) => data.isEmpty ? _buildEmpty() : _buildList(data),
            failure: (error, data) => Center(child: Text(error)),
            empty: (message) => _buildEmpty(),
          );
        },
      ),
    );
  }

  Widget _buildList(List<FavoriteVenueModel> favorites) {
    return RefreshIndicator(
      onRefresh: () => context.read<FavoriteCubit>().getFavorites(),
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
              decoration:
                  BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(16)),
              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.favorite_border_rounded, color: AppColors.white, size: 24),
                SizedBox(height: 4),
                Text('Bỏ YT',
                    style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ]),
            ),
            confirmDismiss: (_) => _removeFavorite(fav).then((_) => false),
            child: FavoriteVenueCard(
              fav: fav,
              onRemove: () => _removeFavorite(fav),
              onBook: () => context.push('/venue-detail/${fav.venue.slug}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 88,
                height: 88,
                decoration:
                    BoxDecoration(color: AppColors.error.withOpacity(0.08), shape: BoxShape.circle),
                child: const Icon(Icons.favorite_border_rounded, size: 44, color: AppColors.error)),
            const SizedBox(height: 16),
            const Text('Chưa có sân yêu thích',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Nhấn ❤️ khi xem chi tiết sân để lưu vào đây',
                style: TextStyle(color: AppColors.textHint, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/main'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBrand,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Khám phá sân ngay',
                  style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
}
