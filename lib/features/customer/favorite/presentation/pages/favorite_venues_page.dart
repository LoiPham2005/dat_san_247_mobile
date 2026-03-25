import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/notification/data/models/notification_model.dart';
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
  final List<FavoriteVenueModel> _favorites = [
    FavoriteVenueModel(
      userId: 'u1', venueId: 'v1',
      venueName: 'Sân K34 Phạm Văn Đồng',
      thumbnailUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbc09e99c?w=400&q=80',
      city: 'Hà Nội', district: 'Cầu Giấy',
      address: 'Số 10 Phạm Văn Đồng, Cầu Giấy, Hà Nội',
      rating: 4.7, totalReviews: 128, isActive: true,
      sportTypes: ['FOOTBALL', 'FUTSAL'],
      savedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    FavoriteVenueModel(
      userId: 'u1', venueId: 'v2',
      venueName: 'Sân Thể Thao Vạn Hạnh',
      thumbnailUrl: 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400&q=80',
      city: 'TP.HCM', district: 'Bình Thạnh',
      address: '45 Điện Biên Phủ, Bình Thạnh',
      rating: 4.5, totalReviews: 89, isActive: true,
      sportTypes: ['BADMINTON', 'PICKLEBALL'],
      savedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    FavoriteVenueModel(
      userId: 'u1', venueId: 'v3',
      venueName: 'Sân Bóng Đá Mỹ Đình Arena',
      city: 'Hà Nội', district: 'Nam Từ Liêm',
      address: 'Khu liên hiệp thể thao Mỹ Đình',
      rating: 4.9, totalReviews: 302, isActive: true,
      sportTypes: ['FOOTBALL'],
      savedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  Future<void> _removeFavorite(FavoriteVenueModel fav) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Bỏ yêu thích?'),
        content: Text('Bỏ "${fav.venueName}" khỏi danh sách yêu thích?'),
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
    if (confirmed == true) {
      setState(() => _favorites.remove(fav));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('💔 Đã bỏ khỏi yêu thích'), duration: Duration(seconds: 2)));
      }
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
        title: Text(
          _favorites.isEmpty ? 'Sân yêu thích' : 'Sân yêu thích (${_favorites.length})',
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: _favorites.isEmpty ? _buildEmpty() : _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favorites.length,
      itemBuilder: (ctx, i) {
        final fav = _favorites[i];
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
            onBook: () => context.push('/venue-detail/${fav.venueId}'),
          ),
        );
      },
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
