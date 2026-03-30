import 'dart:io';
import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/services/venue_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class OwnerVenueRepository with ApiHandlerMixin {
  final OwnerVenueService _service;

  OwnerVenueRepository(this._service);

  /// 🏟️ Fetch all owner venues
  Future<Result<List<OwnerVenueModel>>> getOwnerVenues() {
    return safeCallUnwrap(() => _service.getOwnerVenues());
  }

  /// 🏟️ Get venue detail
  Future<Result<OwnerVenueModel>> getVenueDetail(String id) {
    return safeCallUnwrap(() => _service.getVenueDetail(id));
  }

  /// 📝 Create a new venue
  Future<Result<OwnerVenueModel>> createVenue(Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.createVenue(data));
  }

  /// 📝 Update venue info
  Future<Result<OwnerVenueModel>> updateVenue(String id, Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.updateVenue(id, data));
  }

  /// 🎾 Get courts for a venue
  Future<Result<List<OwnerCourtModel>>> getVenueCourts(String venueId) {
    return safeCallUnwrap(() => _service.getVenueCourts(venueId));
  }

  /// 🎾 Add a new court
  Future<Result<OwnerCourtModel>> addCourt(String venueId, Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.createCourt(venueId, data));
  }

  /// 🎾 Delete a court
  Future<Result<void>> deleteCourt(String venueId, String courtId) {
    return safeCallUnwrap(() => _service.deleteCourt(venueId, courtId)).thenMap((_) => null);
  }

  /// 🏷️ Get pricing rules for a court
  Future<Result<List<OwnerPricingRuleModel>>> getCourtPricingRules(String courtId) {
    return safeCallUnwrap(() => _service.getCourtPricingRules(courtId));
  }

  /// ✨ Update pricing rules
  Future<Result<bool>> updatePricingRules(String courtId, List<OwnerPricingRuleModel> rules) {
    return safeCallUnwrap(() => _service.updatePricingRules(courtId, {
      'rules': rules.map((r) => {
        'name': r.name,
        'day_of_week': r.dayOfWeek,
        'start_time': r.startTime,
        'end_time': r.endTime,
        'price': r.price,
        'priority': r.priority,
        'is_active': r.isActive,
      }).toList(),
    })).thenMap((_) => true);
  }

  /// 🛠️ Get services for a venue
  Future<Result<List<VenueServiceModel>>> getVenueServices(String venueId) {
    return safeCallUnwrap(() => _service.getVenueServices(venueId));
  }

  /// 🛠️ Add service
  Future<Result<VenueServiceModel>> addVenueService(String venueId, Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.addVenueService(venueId, data));
  }

  /// 🛠️ Update service
  Future<Result<VenueServiceModel>> updateVenueService(String venueId, String serviceId, Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.updateVenueService(venueId, serviceId, data));
  }

  /// 🛠️ Delete service
  Future<Result<void>> deleteVenueService(String venueId, String serviceId) {
    return safeCallUnwrap(() => _service.deleteVenueService(venueId, serviceId)).thenMap((_) => null);
  }

  /// 🛡️ Get refund policy
  Future<Result<RefundPolicyModel>> getRefundPolicy(String venueId) {
    return safeCallUnwrap(() => _service.getRefundPolicy(venueId));
  }

  /// 🛋️ Get amenities for a venue
  Future<Result<List<AmenityModel>>> getVenueAmenities(String venueId) {
    return safeCallUnwrap(() => _service.getVenueAmenities(venueId));
  }

  /// ➕ Add amenity
  Future<Result<AmenityModel>> addVenueAmenity(String venueId, String name, String? icon, bool isFree) {
    return safeCallUnwrap(() => _service.addVenueAmenity(venueId, {
      'name': name,
      'icon': icon,
      'is_free': isFree,
    }));
  }

  /// ❌ Delete amenity
  Future<Result<void>> deleteVenueAmenity(String venueId, String amenityId) {
    return safeCallUnwrap(() => _service.deleteVenueAmenity(venueId, amenityId)).thenMap((_) => null);
  }

  /// 📝 Update amenity
  Future<Result<AmenityModel>> updateVenueAmenity(String venueId, String amenityId, {String? name, String? icon, bool? isFree}) {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (icon != null) data['icon'] = icon;
    if (isFree != null) data['is_free'] = isFree;
    return safeCallUnwrap(() => _service.updateVenueAmenity(venueId, amenityId, data));
  }

  /// ⏰ Get operating hours
  Future<Result<List<VenueOperatingHoursModel>>> getOperatingHours(String venueId) {
    return safeCallUnwrap(() => _service.getOperatingHours(venueId));
  }

  /// ⏰ Update operating hours
  Future<Result<void>> updateOperatingHours(String venueId, List<VenueOperatingHoursModel> hours) {
    return safeCallUnwrap(() => _service.updateOperatingHours(venueId, {
      'hours': hours.map((h) => {
        'day_of_week': h.dayOfWeek.name,
        'opening_time': h.openingTime,
        'closing_time': h.closingTime,
        'is_closed': h.isClosed,
      }).toList(),
    })).thenMap((_) => null);
  }

  /// 📅 Get schedule exceptions
  Future<Result<List<VenueScheduleExceptionModel>>> getScheduleExceptions(String venueId) {
    return safeCallUnwrap(() => _service.getScheduleExceptions(venueId));
  }

  /// ➕ Add schedule exception
  Future<Result<VenueScheduleExceptionModel>> addScheduleException(String venueId, VenueScheduleExceptionModel exception) {
    return safeCallUnwrap(() => _service.createScheduleException(venueId, {
      'date': exception.date.toIso8601String(),
      'opening_time': exception.openTime,
      'closing_time': exception.closeTime,
      'is_closed': exception.isClosed,
      'reason': exception.reason,
    }));
  }

  /// ❌ Delete schedule exception
  Future<Result<void>> deleteScheduleException(String venueId, String exceptionId) {
    return safeCallUnwrap(() => _service.deleteScheduleException(venueId, exceptionId)).thenMap((_) => null);
  }

  /// 🖼️ Get media attachments
  Future<Result<List<MediaAttachmentModel>>> getMediaAttachments(String venueId) {
    return safeCallUnwrap(() => _service.getMediaAttachments(venueId));
  }

  /// ➕ Add media
  Future<Result<MediaAttachmentModel>> addMediaAttachment(String venueId, String url) {
    return safeCallUnwrap(() => _service.createMediaAttachment(venueId, {
      'public_url': url,
    }));
  }

  /// 📤 Upload file
  Future<Result<String>> uploadFile(File file) {
    return safeCallUnwrap(() => _service.uploadFile(file)).thenMap((data) => data.url);
  }

  /// ❌ Delete media
  Future<Result<void>> deleteMediaAttachment(String venueId, String mediaId) {
    return safeCallUnwrap(() => _service.deleteMediaAttachment(venueId, mediaId)).thenMap((_) => null);
  }

  /// ⭐ Set cover
  Future<Result<MediaAttachmentModel>> setCoverMedia(String venueId, String mediaId) {
    return safeCallUnwrap(() => _service.setCoverMedia(venueId, mediaId));
  }

  /// 🛡️ Get verification status
  Future<Result<VenueVerificationModel>> getVerification(String venueId) {
    return safeCallUnwrap(() => _service.getVerification(venueId));
  }

  /// 🛡️ Submit verification
  Future<Result<VenueVerificationModel>> submitVerification(String venueId, Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.submitVerification(venueId, data));
  }
}
