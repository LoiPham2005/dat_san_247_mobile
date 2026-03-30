import 'package:dat_san_247_mobile/features/customer/profile/data/models/profile_models.dart';
import 'package:dat_san_247_mobile/features/customer/profile/data/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/base/state/cubit/base_cubit.dart';

@injectable
class ProfileCubit extends BaseCubit<UserModel> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super();

  Future<void> fetchProfile() async {
    await run(
      action: () => _repository.getProfile(),
    );
  }

  Future<void> updateBasicProfile({
    String? fullName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? bio,
    String? address,
    String? city,
    String? district,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (gender != null) body['gender'] = gender.name;
    if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth.toIso8601String();
    if (bio != null) body['bio'] = bio;
    if (address != null) body['address'] = address;
    if (city != null) body['city'] = city;
    if (district != null) body['district'] = district;

    await run(
      action: () => _repository.updateProfile(body),
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
  }) async {
    final body = <String, dynamic>{};
    if (notifPush != null) body['notif_push'] = notifPush;
    if (notifEmail != null) body['notif_email'] = notifEmail;
    if (notifSms != null) body['notif_sms'] = notifSms;
    if (notifBooking != null) body['notif_booking'] = notifBooking;
    if (notifPromotion != null) body['notif_promotion'] = notifPromotion;
    if (notifPayment != null) body['notif_payment'] = notifPayment;
    if (notifSystem != null) body['notif_system'] = notifSystem;
    if (notifStaff != null) body['notif_staff'] = notifStaff;

    await run(
      action: () => _repository.updateProfile(body),
      successMessage: 'Đã lưu cài đặt thông báo',
    );
  }

  Future<void> updateSportPreference(String sportType, int skillLevel) async {
    final result = await _repository.updateSportPreference({
      'sport_type': sportType,
      'skill_level': skillLevel,
    });

    result.fold(
      onSuccess: (pref) {
        // Refresh full profile to get updated preferences list
        fetchProfile();
      },
      onFailure: (failure) {
        // Handle failure if needed, run() normally takes care of state but manually folding here
      },
    );
  }
}
