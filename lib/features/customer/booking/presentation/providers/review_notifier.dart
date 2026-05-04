import 'dart:io';

import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/errors/failures.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_notifier.g.dart';

@riverpod
class ReviewNotifier extends _$ReviewNotifier with BaseNotifier<void> {
  late final BookingRepository _repository;

  @override
  Future<void> build() async {
    _repository = getIt<BookingRepository>();
  }

  Future<void> submitReview(
    ReviewRequest request, {
    List<File>? imageFiles,
    File? videoFile,
  }) =>
      runAsync(
        action: () async {
          final imageUrls = <String>[];
          String? videoUrl;

          if (imageFiles != null && imageFiles.isNotEmpty) {
            for (final file in imageFiles) {
              final res = await _repository.uploadReviewFile(file);
              res.fold(
                onSuccess: imageUrls.add,
                onFailure: (f) =>
                    throw ServerFailure(message: 'Tải lên ảnh thất bại: ${f.message}'),
              );
            }
          }

          if (videoFile != null) {
            final res = await _repository.uploadReviewFile(videoFile);
            res.fold(
              onSuccess: (url) => videoUrl = url,
              onFailure: (f) =>
                  throw ServerFailure(message: 'Tải lên video thất bại: ${f.message}'),
            );
          }

          final updatedRequest = request.copyWith(
            images: imageUrls.isEmpty ? null : imageUrls,
            videos: videoUrl == null ? null : [videoUrl!],
          );

          final result = await _repository.submitReview(updatedRequest);
          result.fold(
            onSuccess: (_) => null,
            onFailure: (f) => throw f,
          );
        },
        successMessage: 'Cảm ơn bạn đã đánh giá!',
      );
}
