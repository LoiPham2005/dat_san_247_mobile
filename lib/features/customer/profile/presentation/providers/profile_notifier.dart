import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/profile/data/models/profile_models.dart';
import 'package:dat_san_247_mobile/features/customer/profile/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier with BaseNotifier<UserModel> {
  late final ProfileRepository _repository;

  @override
  Future<UserModel> build() async {
    _repository = getIt<ProfileRepository>();
    final result = await _repository.getProfile();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getProfile,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
      );

  Future<void> updateBasicProfile({
    String? fullName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? bio,
    String? address,
    String? city,
    String? district,
  }) {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (gender != null) body['gender'] = gender.name;
    if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth.toIso8601String();
    if (bio != null) body['bio'] = bio;
    if (address != null) body['address'] = address;
    if (city != null) body['city'] = city;
    if (district != null) body['district'] = district;

    return runResult(
      action: () => _repository.updateProfile(body),
      mapper: (data) => data,
      successMessage: 'Cập nhật thông tin thành công',
    );
  }

  Future<void> updateNotificationSettings({
    bool? notifPush,
    bool? notifEmail,
    bool? notifSms,
    bool? notifBooking,
    bool? notifPromotion,
    bool? notifPayment,
    bool? notifSystem,
    bool? notifStaff,
  }) {
    final body = <String, dynamic>{};
    if (notifPush != null) body['notif_push'] = notifPush;
    if (notifEmail != null) body['notif_email'] = notifEmail;
    if (notifSms != null) body['notif_sms'] = notifSms;
    if (notifBooking != null) body['notif_booking'] = notifBooking;
    if (notifPromotion != null) body['notif_promotion'] = notifPromotion;
    if (notifPayment != null) body['notif_payment'] = notifPayment;
    if (notifSystem != null) body['notif_system'] = notifSystem;
    if (notifStaff != null) body['notif_staff'] = notifStaff;

    return runResult(
      action: () => _repository.updateProfile(body),
      mapper: (data) => data,
      successMessage: 'Đã lưu cài đặt thông báo',
    );
  }

  Future<void> updateSportPreference(String sportType, int skillLevel) async {
    final result = await _repository.updateSportPreference({
      'sport_type': sportType,
      'skill_level': skillLevel,
    });
    if (result.isSuccess) await refresh();
  }
}
