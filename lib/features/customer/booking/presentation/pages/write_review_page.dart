import 'dart:io';

import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/common/utils/image_picker_helper.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/providers/review_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-12: Viết Đánh Giá
// ──────────────────────────────────────────────────────────────────────────
class WriteReviewPage extends HookConsumerWidget {
  final String bookingId;
  final String venueName;

  const WriteReviewPage({
    super.key,
    required this.bookingId,
    required this.venueName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingOverall = useState(0);
    final ratingCleanliness = useState(0);
    final ratingFacilities = useState(0);
    final ratingStaff = useState(0);
    final commentController = useTextEditingController();
    final selectedImages = useState<List<File>>([]);
    final selectedVideo = useState<File?>(null);

    final state = ref.watch(reviewProvider);
    final notifier = ref.read(reviewProvider.notifier);
    final isSubmitting = state.isLoading;

    RiverpodListeners.async$(
      ref: ref,
      context: context,
      provider: reviewProvider,
      notifier: notifier,
      onSuccess: (_) {
        // Quay về My Bookings (Pop WriteReview & BookingDetail)
        Navigator.of(context).pop();
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      },
    );

    final canSubmit = ratingOverall.value > 0;

    Future<void> pickImages() async {
      final images = await ImagePickerHelper.pickMultiple(
        context,
        maxCount: 5 - selectedImages.value.length,
      );
      if (images.isNotEmpty) {
        selectedImages.value = [...selectedImages.value, ...images];
      }
    }

    Future<void> pickVideo() async {
      final video = await ImagePickerHelper.pickVideo(context);
      if (video != null) selectedVideo.value = video;
    }

    void submit() {
      if (!canSubmit) {
        toast.error('Vui lòng đánh giá tổng (số sao)');
        return;
      }
      notifier.submitReview(
        ReviewRequest(
          bookingId: bookingId,
          rating: ratingOverall.value,
          ratingCleanliness:
              ratingCleanliness.value > 0 ? ratingCleanliness.value : null,
          ratingFacilities:
              ratingFacilities.value > 0 ? ratingFacilities.value : null,
          ratingStaff: ratingStaff.value > 0 ? ratingStaff.value : null,
          comment: commentController.text.trim(),
        ),
        imageFiles: selectedImages.value,
        videoFile: selectedVideo.value,
      );
    }

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
        title: const Text('Viết đánh giá',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightBrand.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sports_soccer_rounded,
                        color: AppColors.primaryLightBrand, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(venueName,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const Text(
                          'Đánh giá sẽ giúp các người dùng khác chọn sân tốt hơn',
                          style: TextStyle(fontSize: 11, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDeco(),
              child: Column(
                children: [
                  const Text('Đánh giá tổng *',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    ratingOverall.value == 0
                        ? 'Chưa đánh giá'
                        : _labelFromRating(ratingOverall.value),
                    style: TextStyle(
                        fontSize: 13,
                        color: ratingOverall.value > 0
                            ? AppColors.warning
                            : AppColors.textHint),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return GestureDetector(
                        onTap: () => ratingOverall.value = star,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            star <= ratingOverall.value
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: star <= ratingOverall.value
                                ? AppColors.warning
                                : AppColors.greyLight,
                            size: 44,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Đánh giá chi tiết',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _DetailRatingRow(
                    label: '🧹 Vệ sinh sân',
                    rating: ratingCleanliness.value,
                    onChanged: (v) => ratingCleanliness.value = v,
                  ),
                  const SizedBox(height: 12),
                  _DetailRatingRow(
                    label: '🏟️ Cơ sở vật chất',
                    rating: ratingFacilities.value,
                    onChanged: (v) => ratingFacilities.value = v,
                  ),
                  const SizedBox(height: 12),
                  _DetailRatingRow(
                    label: '👷 Nhân viên',
                    rating: ratingStaff.value,
                    onChanged: (v) => ratingStaff.value = v,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nhận xét của bạn',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Chia sẻ trải nghiệm của bạn để giúp người khác...',
                    style: TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    maxLength: 500,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Sân sạch sẽ, nhân viên nhiệt tình, mặt cỏ tốt...',
                      hintStyle:
                          const TextStyle(color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.mutedLight,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thêm ảnh',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Tối đa 5 ảnh (JPG, PNG)',
                      style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...selectedImages.value.map((file) => _MediaPreview(
                            file: file,
                            onRemove: () {
                              selectedImages.value = selectedImages.value
                                  .where((f) => f != file)
                                  .toList();
                            },
                          )),
                      if (selectedImages.value.length < 5)
                        _AddMediaButton(
                          onTap: pickImages,
                          icon: Icons.add_photo_alternate_rounded,
                          label: 'Thêm ảnh',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thêm video',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Tối đa 1 video (MP4, MOV)',
                      style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 12),
                  if (selectedVideo.value != null)
                    _MediaPreview(
                      file: selectedVideo.value!,
                      isVideo: true,
                      onRemove: () => selectedVideo.value = null,
                    )
                  else
                    _AddMediaButton(
                      onTap: pickVideo,
                      icon: Icons.video_call_rounded,
                      label: 'Thêm video',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -4))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ratingOverall.value > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      5,
                      (i) => Icon(
                          i < ratingOverall.value
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.warning,
                          size: 18)),
                  const SizedBox(width: 6),
                  Text(_labelFromRating(ratingOverall.value),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.warning)),
                ],
              ),
            if (ratingOverall.value > 0) const SizedBox(height: 8),
            ElevatedButton(
              onPressed: isSubmitting || !canSubmit ? null : submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 52),
                elevation: 0,
                disabledBackgroundColor: AppColors.greyLight,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: AppColors.white))
                  : const Text('Gửi đánh giá',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFromRating(int r) {
    switch (r) {
      case 1:
        return 'Rất tệ 😞';
      case 2:
        return 'Tệ 😐';
      case 3:
        return 'Bình thường 🙂';
      case 4:
        return 'Tốt 😊';
      case 5:
        return 'Tuyệt vời! 🤩';
      default:
        return '';
    }
  }

  BoxDecoration _cardDeco() => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)
        ],
      );
}

class _DetailRatingRow extends StatelessWidget {
  final String label;
  final int rating;
  final ValueChanged<int> onChanged;
  const _DetailRatingRow({
    required this.label,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ),
        const Spacer(),
        ...List.generate(
          5,
          (i) => GestureDetector(
            onTap: () => onChanged(i + 1),
            child: Icon(
              i < rating ? Icons.star_rounded : Icons.star_border_rounded,
              color: i < rating ? AppColors.warning : AppColors.greyLight,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddMediaButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const _AddMediaButton({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.mutedLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryLightBrand, size: 28),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.primaryLightBrand,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _MediaPreview extends StatelessWidget {
  final File file;
  final bool isVideo;
  final VoidCallback onRemove;

  const _MediaPreview({
    required this.file,
    this.isVideo = false,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.mutedLight,
            borderRadius: BorderRadius.circular(10),
            image: !isVideo
                ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                : null,
          ),
          child: isVideo
              ? const Center(
                  child: Icon(Icons.play_circle_fill_rounded,
                      color: AppColors.primaryLightBrand, size: 36))
              : null,
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration:
                  const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded,
                  color: AppColors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}
