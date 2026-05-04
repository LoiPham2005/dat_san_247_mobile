import 'dart:io';

import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/errors/failures.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_verification_notifier.freezed.dart';
part 'owner_verification_notifier.g.dart';

@freezed
abstract class OwnerVerificationData with _$OwnerVerificationData {
  const factory OwnerVerificationData({
    VenueVerificationModel? verification,
    @Default({}) Map<String, String?> filePaths,
    @Default(false) bool isSubmitting,
  }) = _OwnerVerificationData;
}

@riverpod
class OwnerVerificationNotifier extends _$OwnerVerificationNotifier
    with BaseNotifier<OwnerVerificationData> {
  late final OwnerVenueRepository _repository;
  late final String _venueId;

  @override
  Future<OwnerVerificationData> build(String venueId) async {
    _repository = getIt<OwnerVenueRepository>();
    _venueId = venueId;
    final res = await _repository.getVerification(venueId);
    final verification = res.fold(
      onSuccess: (data) => data,
      onFailure: (_) => null,
    );
    return OwnerVerificationData(verification: verification);
  }

  void updateFilePath(String key, String? path) {
    final current = currentData ?? const OwnerVerificationData();
    final paths = Map<String, String?>.from(current.filePaths);
    paths[key] = path;
    state = AsyncData(current.copyWith(filePaths: paths));
  }

  Future<void> submitVerification() async {
    final current = currentData;
    if (current == null) return;
    final paths = current.filePaths;
    if (paths.values.any((v) => v == null)) {
      state = AsyncError(
        const ServerFailure(message: 'Vui lòng chọn đầy đủ 4 loại giấy tờ'),
        StackTrace.current,
      );
      return;
    }

    state = AsyncData(current.copyWith(isSubmitting: true));

    final uploadedUrls = <String, String>{};
    for (final entry in paths.entries) {
      final file = File(entry.value!);
      final uploadRes = await _repository.uploadFile(file);
      var stop = false;
      uploadRes.fold(
        onFailure: (err) {
          state = AsyncError(
            ServerFailure(message: 'Lỗi tải tệp ${entry.key}: ${err.message}'),
            StackTrace.current,
          );
          stop = true;
        },
        onSuccess: (url) => uploadedUrls[entry.key] = url,
      );
      if (stop) return;
    }

    final dto = {
      'business_license_url': uploadedUrls['business_license'],
      'id_card_front_url': uploadedUrls['id_card_front'],
      'id_card_back_url': uploadedUrls['id_card_back'],
      'owner_photo_url': uploadedUrls['owner_photo'],
    };

    final res = await _repository.submitVerification(_venueId, dto);
    res.fold(
      onFailure: (err) {
        state = AsyncError(err, StackTrace.current);
      },
      onSuccess: (data) {
        state = AsyncData(current.copyWith(
          verification: data,
          filePaths: {},
          isSubmitting: false,
        ));
      },
    );
  }
}
