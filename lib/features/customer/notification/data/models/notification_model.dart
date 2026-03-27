import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

// ── Enums (schema.prisma) ──────────────────────────────────────────────────

enum NotificationType {
  BOOKING_CONFIRMED,
  BOOKING_CANCELLED,
  BOOKING_REMINDER,
  PAYMENT_SUCCESS,
  PAYMENT_FAILED,
  REVIEW_RESPONSE,
  WAITLIST_AVAILABLE,
  PROMOTION,
  SYSTEM;

  String get icon {
    switch (this) {
      case BOOKING_CONFIRMED:
        return '✅';
      case BOOKING_CANCELLED:
        return '❌';
      case BOOKING_REMINDER:
        return '⏰';
      case PAYMENT_SUCCESS:
        return '💳';
      case PAYMENT_FAILED:
        return '⚠️';
      case REVIEW_RESPONSE:
        return '⭐';
      case WAITLIST_AVAILABLE:
        return '🎉';
      case PROMOTION:
        return '🎁';
      case SYSTEM:
        return '🔔';
    }
  }
}

enum NotificationChannel { PUSH, EMAIL, SMS, IN_APP }

enum NotificationReferenceType {
  BOOKING,
  PAYMENT,
  REVIEW,
  PROMOTION,
  VENUE,
  WAITLIST,
}

// ── notifications model ────────────────────────────────────────────────────
@freezed
abstract class NotificationModel with _$NotificationModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory NotificationModel({
    required String id,
    required String userId,
    @Default(NotificationType.SYSTEM) NotificationType type,
    @Default(NotificationChannel.IN_APP) NotificationChannel channel,
    required String title,
    required String message,
    String? referenceId,
    NotificationReferenceType? referenceType,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── favorite_venues model (dùng chung) ────────────────────────────────────
@freezed
abstract class FavoriteVenueModel with _$FavoriteVenueModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory FavoriteVenueModel({
    required String userId,
    required String venueId,
    required String venueName,
    String? thumbnailUrl,
    required String city,
    required String district,
    required String address,
    required double rating,
    required int totalReviews,
    required bool isActive,
    @Default([]) List<String> sportTypes,
    required DateTime savedAt,
  }) = _FavoriteVenueModel;

  const FavoriteVenueModel._();

  factory FavoriteVenueModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    final venue = json['venues'] as Map<String, dynamic>? ?? {};

    mappedJson['venue_name'] = venue['name'] ?? '';
    mappedJson['thumbnail_url'] = venue['thumbnail_url'];
    mappedJson['city'] = venue['city'] ?? '';
    mappedJson['district'] = venue['district'] ?? '';
    mappedJson['address'] = venue['address'] ?? '';
    mappedJson['rating'] = (venue['rating'] as num?)?.toDouble() ?? 0;
    mappedJson['total_reviews'] = venue['total_reviews'] ?? 0;
    mappedJson['is_active'] = venue['is_active'] ?? true;
    mappedJson['sport_types'] = (venue['sport_assignments'] as List? ?? [])
        .map((s) => s['sport_type']?.toString() ?? '')
        .toList();
    mappedJson['saved_at'] = json['created_at'];

    return _$FavoriteVenueModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}
