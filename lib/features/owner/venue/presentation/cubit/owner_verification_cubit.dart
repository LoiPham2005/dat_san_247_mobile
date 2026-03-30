import 'dart:io';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'owner_verification_cubit.freezed.dart';

@freezed
abstract class OwnerVerificationState with _$OwnerVerificationState {
  const factory OwnerVerificationState({
    VenueVerificationModel? verification,
    @Default({}) Map<String, String?> filePaths,
    @Default(false) bool isSubmitting,
  }) = _OwnerVerificationState;
}

@injectable
class OwnerVerificationCubit extends BaseCubit<OwnerVerificationState> {
  final OwnerVenueRepository _repository;
  OwnerVerificationCubit(this._repository) : super(const BaseState(status: BaseStatus.initial, data: OwnerVerificationState()));

  Future<void> fetchVerification(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    final res = await _repository.getVerification(venueId);
    res.fold(
      onFailure: (err) => emit(BaseState.failure(error: err.message, previousData: state.data)),
      onSuccess: (data) => emit(BaseState.success(data: state.data?.copyWith(verification: data))),
    );
  }

  void updateFilePath(String key, String? path) {
    final currentPaths = Map<String, String?>.from(state.data?.filePaths ?? {});
    currentPaths[key] = path;
    emit(BaseState.success(data: state.data?.copyWith(filePaths: currentPaths)));
  }

  Future<void> submitVerification(String venueId) async {
    final paths = state.data?.filePaths ?? {};
    if (paths.values.any((v) => v == null)) {
       emit(BaseState.failure(error: 'Vui lòng chọn đầy đủ 4 loại giấy tờ', previousData: state.data));
       return;
    }

    emit(BaseState.loading(previousData: state.data?.copyWith(isSubmitting: true)));

    // 1. Upload files
    final Map<String, String> uploadedUrls = {};
    for (final entry in paths.entries) {
       final file = File(entry.value!);
       final uploadRes = await _repository.uploadFile(file);
       bool stop = false;
       uploadRes.fold(
         onFailure: (err) {
            emit(BaseState.failure(error: 'Lỗi khi tải tệp ${entry.key}: ${err.message}', previousData: state.data?.copyWith(isSubmitting: false)));
            stop = true;
         },
         onSuccess: (url) => uploadedUrls[entry.key] = url,
       );
       if (stop) return;
    }

    // 2. Submit verification with URLs
    // Map keys to backend snake_case expected fields
    final dto = {
      'business_license_url': uploadedUrls['business_license'],
      'id_card_front_url': uploadedUrls['id_card_front'],
      'id_card_back_url': uploadedUrls['id_card_back'],
      'owner_photo_url': uploadedUrls['owner_photo'],
    };

    final res = await _repository.submitVerification(venueId, dto);
    res.fold(
      onFailure: (err) => emit(BaseState.failure(error: err.message, previousData: state.data?.copyWith(isSubmitting: false))),
      onSuccess: (data) => emit(BaseState.success(
        message: 'Đã gửi hồ sơ xét duyệt thành công',
        data: state.data?.copyWith(verification: data, filePaths: {}, isSubmitting: false)
      )),
    );
  }
}
