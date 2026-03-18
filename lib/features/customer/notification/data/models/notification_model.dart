import 'package:equatable/equatable.dart';

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
      case BOOKING_CONFIRMED: return '✅';
      case BOOKING_CANCELLED: return '❌';
      case BOOKING_REMINDER: return '⏰';
      case PAYMENT_SUCCESS: return '💳';
      case PAYMENT_FAILED: return '⚠️';
      case REVIEW_RESPONSE: return '⭐';
      case WAITLIST_AVAILABLE: return '🎉';
      case PROMOTION: return '🎁';
      case SYSTEM: return '🔔';
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
class NotificationModel extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final NotificationChannel channel;
  final String title;
  final String message;
  final String? referenceId;
  final NotificationReferenceType? referenceType;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.channel,
    required this.title,
    required this.message,
    this.referenceId,
    this.referenceType,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        userId: json['user_id'],
        type: NotificationType.values.firstWhere(
            (e) => e.name == json['type'],
            orElse: () => NotificationType.SYSTEM),
        channel: NotificationChannel.values.firstWhere(
            (e) => e.name == json['channel'],
            orElse: () => NotificationChannel.IN_APP),
        title: json['title'],
        message: json['message'],
        referenceId: json['reference_id'],
        referenceType: json['reference_type'] != null
            ? NotificationReferenceType.values.firstWhere(
                (e) => e.name == json['reference_type'],
                orElse: () => NotificationReferenceType.BOOKING)
            : null,
        isRead: json['is_read'] ?? false,
        readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
        createdAt: DateTime.parse(json['created_at']),
      );

  @override
  List<Object?> get props => [id, isRead, type];
}

// ── favorite_venues model (dùng chung) ────────────────────────────────────
class FavoriteVenueModel extends Equatable {
  final String userId;
  final String venueId;
  final String venueName;
  final String? thumbnailUrl;
  final String city;
  final String district;
  final String address;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final List<String> sportTypes;  // từ sport_assignments
  final DateTime savedAt;         // favorite_venues.created_at

  const FavoriteVenueModel({
    required this.userId,
    required this.venueId,
    required this.venueName,
    this.thumbnailUrl,
    required this.city,
    required this.district,
    required this.address,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    this.sportTypes = const [],
    required this.savedAt,
  });

  factory FavoriteVenueModel.fromJson(Map<String, dynamic> json) {
    final venue = json['venues'] as Map<String, dynamic>? ?? {};
    return FavoriteVenueModel(
      userId: json['user_id'],
      venueId: json['venue_id'],
      venueName: venue['name'] ?? '',
      thumbnailUrl: venue['thumbnail_url'],
      city: venue['city'] ?? '',
      district: venue['district'] ?? '',
      address: venue['address'] ?? '',
      rating: (venue['rating'] as num?)?.toDouble() ?? 0,
      totalReviews: venue['total_reviews'] ?? 0,
      isActive: venue['is_active'] ?? true,
      sportTypes: (venue['sport_assignments'] as List? ?? [])
          .map((s) => s['sport_type']?.toString() ?? '')
          .toList(),
      savedAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [userId, venueId];
}
