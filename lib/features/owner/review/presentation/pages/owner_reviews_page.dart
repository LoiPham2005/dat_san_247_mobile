import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/models/owner_review_model.dart';
import 'package:dat_san_247_mobile/features/owner/review/presentation/providers/owner_review_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class OwnerReviewsPage extends ConsumerWidget {
  final String? venueId;
  final String? venueName;
  const OwnerReviewsPage({super.key, this.venueId, this.venueName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ownerReviewProvider(venueId);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    useAsyncValueListener(provider: provider, ref: ref);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Đánh Giá của Khách',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (venueName != null)
              Text(venueName!,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: switch (state) {
        AsyncData(:final value) when value.isEmpty => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('Chưa có đánh giá nào',
                    style: TextStyle(color: AppColors.textHint)),
              ],
            ),
          ),
        AsyncData(:final value) => RefreshIndicator(
            onRefresh: notifier.refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: value.length,
              itemBuilder: (ctx, i) =>
                  _ReviewCard(review: value[i], notifier: notifier),
            ),
          ),
        AsyncError(:final error) => Center(child: Text('Lỗi: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final OwnerReviewModel review;
  final OwnerReviewNotifier notifier;
  const _ReviewCard({required this.review, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final hasResp = review.response != null && review.response!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Customer Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: review.users?.avatarUrl != null ? NetworkImage(review.users!.avatarUrl!) : null,
                  backgroundColor: Colors.blue.shade100,
                  child: review.users?.avatarUrl == null ? Text(review.users?.fullName[0].toUpperCase() ?? '?') : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.users?.fullName ?? 'Khách ẩn danh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(review.createdAt),
                        style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
                _buildRatingBadge(review.rating),
              ],
            ),
          ),

          // Venue/Court Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${review.venues?.name ?? "Cơ sở"}${review.courts != null ? ' - ${review.courts!.name}' : ''}',
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (review.comment != null && review.comment!.isNotEmpty)
                  Text(review.comment!, style: const TextStyle(fontSize: 13, height: 1.4)),
                
                // Media
                if (review.mediaAttachments.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: review.mediaAttachments.length,
                      itemBuilder: (ctx, i) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(review.mediaAttachments[i].publicUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // Ratings Detail
                const SizedBox(height: 12),
                Row(
                  children: [
                    _SmallRating('Sạch sẽ', review.ratingCleanliness),
                    const SizedBox(width: 12),
                    _SmallRating('Cơ sở vật chất', review.ratingFacilities),
                    const SizedBox(width: 12),
                    _SmallRating('Phục vụ', review.ratingStaff),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Owner Response
          if (hasResp)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.reply_rounded, size: 14, color: Colors.blue),
                      SizedBox(width: 6),
                      Text('Phản hồi từ chủ sân', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(review.response!, style: const TextStyle(fontSize: 12, height: 1.4, fontStyle: FontStyle.italic)),
                  if (review.respondedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(review.respondedAt!),
                      style: const TextStyle(fontSize: 9, color: AppColors.textHint),
                    ),
                  ]
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () => _showReplySheet(context, review),
                icon: const Icon(Icons.reply_rounded, size: 16),
                label: const Text('Phản hồi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: rating >= 4 ? Colors.green.shade50 : (rating >= 3 ? Colors.orange.shade50 : Colors.red.shade50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 16,
            color: rating >= 4 ? Colors.green : (rating >= 3 ? Colors.orange : Colors.red),
          ),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: rating >= 4 ? Colors.green : (rating >= 3 ? Colors.orange : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showReplySheet(BuildContext context, OwnerReviewModel review) {
    final replyCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Phản hồi đánh giá', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.users?.fullName ?? 'Khách ẩn danh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(review.comment ?? 'Không có bình luận', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: replyCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Nhập phản hồi của bạn...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (replyCtrl.text.trim().isEmpty) return;
                    Navigator.pop(ctx);
                    notifier.replyReview(review.id, replyCtrl.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0891B2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Gửi Phản Hồi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallRating extends StatelessWidget {
  final String label;
  final double rating;
  const _SmallRating(this.label, this.rating);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 10, color: Colors.orange),
            const SizedBox(width: 2),
            Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
