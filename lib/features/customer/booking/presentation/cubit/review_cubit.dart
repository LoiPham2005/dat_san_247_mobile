import 'dart:io';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReviewCubit extends BaseCubit<void> {
  final BookingRepository _repository;

  ReviewCubit(this._repository) : super(BaseState.initial());

  Future<void> submitReview(ReviewRequest request, {List<File>? imageFiles, File? videoFile}) async {
    safeEmit(BaseState.loading());

    try {
      final List<String> imageUrls = [];
      String? videoUrl;

      // 1. Upload Images
      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (final file in imageFiles) {
          final res = await _repository.uploadReviewFile(file);
          res.fold(
            onSuccess: (url) => imageUrls.add(url),
            onFailure: (f) => throw Exception('Tải lên ảnh thất bại: ${f.message}'),
          );
        }
      }

      // 2. Upload Video
      if (videoFile != null) {
        final res = await _repository.uploadReviewFile(videoFile);
        res.fold(
          onSuccess: (url) => videoUrl = url,
          onFailure: (f) => throw Exception('Tải lên video thất bại: ${f.message}'),
        );
      }

      // 3. Submit Review with URLs
      final updatedRequest = request.copyWith(
        images: imageUrls.isEmpty ? null : imageUrls,
        videos: videoUrl == null ? null : [videoUrl!],
      );

      final result = await _repository.submitReview(updatedRequest);

      result.fold(
        onSuccess: (_) => emit(BaseState.success(message: 'Cảm ơn bạn đã đánh giá!')),
        onFailure: (failure) => emit(BaseState.failure(error: failure.message)),
      );
    } catch (e) {
      emit(BaseState.failure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
