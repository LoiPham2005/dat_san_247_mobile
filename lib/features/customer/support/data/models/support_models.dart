import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_models.freezed.dart';
part 'support_models.g.dart';

// ──────────────────────────────────────────────────────────────────────────
// Enums (mapping schema.prisma)
// ──────────────────────────────────────────────────────────────────────────

enum SupportTicketStatus {
  OPEN,
  IN_PROGRESS,
  RESOLVED,
  CLOSED,
  REOPENED;

  String get label {
    switch (this) {
      case OPEN: return 'Đang mở';
      case IN_PROGRESS: return 'Đang xử lý';
      case RESOLVED: return 'Đã giải quyết';
      case CLOSED: return 'Đã đóng';
      case REOPENED: return 'Mở lại';
    }
  }

  bool get isActive => this == OPEN || this == IN_PROGRESS || this == REOPENED;
}

enum SupportTicketPriority {
  LOW, MEDIUM, HIGH, URGENT;

  String get label {
    switch (this) {
      case LOW: return 'Thấp';
      case MEDIUM: return 'Trung bình';
      case HIGH: return 'Cao';
      case URGENT: return 'Khẩn cấp';
    }
  }
}

enum SupportTicketCategory {
  BOOKING_ISSUE,
  PAYMENT_ISSUE,
  VENUE_ISSUE,
  ACCOUNT_ISSUE,
  REFUND_REQUEST,
  OTHER;

  String get label {
    switch (this) {
      case BOOKING_ISSUE: return 'Vấn đề đặt sân';
      case PAYMENT_ISSUE: return 'Vấn đề thanh toán';
      case VENUE_ISSUE: return 'Vấn đề sân bãi';
      case ACCOUNT_ISSUE: return 'Vấn đề tài khoản';
      case REFUND_REQUEST: return 'Yêu cầu hoàn tiền';
      case OTHER: return 'Khác';
    }
  }

  String get icon {
    switch (this) {
      case BOOKING_ISSUE: return '📅';
      case PAYMENT_ISSUE: return '💳';
      case VENUE_ISSUE: return '🏟️';
      case ACCOUNT_ISSUE: return '👤';
      case REFUND_REQUEST: return '↩️';
      case OTHER: return '💬';
    }
  }
}

enum ReportTargetType {
  USER, VENUE, REVIEW, TRANSACTION;

  String get label {
    switch (this) {
      case USER: return 'Người dùng';
      case VENUE: return 'Sân bãi';
      case REVIEW: return 'Đánh giá';
      case TRANSACTION: return 'Giao dịch';
    }
  }
}

enum ReportReason {
  SPAM,
  INAPPROPRIATE,
  FAKE,
  FRAUD,
  DISPUTE_TRANSACTION,
  OTHER;

  String get label {
    switch (this) {
      case SPAM: return 'Spam / Quảng cáo';
      case INAPPROPRIATE: return 'Nội dung không phù hợp';
      case FAKE: return 'Thông tin giả mạo';
      case FRAUD: return 'Lừa đảo';
      case DISPUTE_TRANSACTION: return 'Tranh chấp giao dịch';
      case OTHER: return 'Lý do khác';
    }
  }
}

enum KycStatus {
  UNVERIFIED, PENDING, VERIFIED, REJECTED;

  String get label {
    switch (this) {
      case UNVERIFIED: return 'Chưa xác minh';
      case PENDING: return 'Đang xem xét';
      case VERIFIED: return 'Đã xác minh';
      case REJECTED: return 'Bị từ chối';
    }
  }
}

enum Gender { MALE, FEMALE, OTHER;
  String get label => this == MALE ? 'Nam' : this == FEMALE ? 'Nữ' : 'Khác';
}

// ──────────────────────────────────────────────────────────────────────────
// support_ticket_messages model
// ──────────────────────────────────────────────────────────────────────────
@freezed
abstract class TicketMessageModel with _$TicketMessageModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TicketMessageModel({
    required String id,
    required String ticketId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required String message,
    @Default(false) bool isStaff,
    String? attachmentUrl,
    required DateTime createdAt,
  }) = _TicketMessageModel;

  const TicketMessageModel._();

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['users'] != null && json['users'] is Map) {
      mappedJson['sender_name'] = json['users']['full_name'];
      mappedJson['sender_avatar'] = json['users']['avatar_url'];
    }
    return _$TicketMessageModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ──────────────────────────────────────────────────────────────────────────
// support_tickets model
// ──────────────────────────────────────────────────────────────────────────
@freezed
abstract class SupportTicketModel with _$SupportTicketModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SupportTicketModel({
    required String id,
    required String ticketNumber,
    required String customerId,
    @Default(SupportTicketCategory.OTHER) SupportTicketCategory category,
    @Default(SupportTicketPriority.MEDIUM) SupportTicketPriority priority,
    @Default(SupportTicketStatus.OPEN) SupportTicketStatus status,
    required String subject,
    required String description,
    String? bookingId,
    String? bookingCode,
    String? venueId,
    String? venueName,
    String? resolution,
    DateTime? resolvedAt,
    DateTime? firstResponseAt,
    int? customerRating,
    String? customerFeedback,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<TicketMessageModel> messages,
  }) = _SupportTicketModel;

  const SupportTicketModel._();

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['bookings'] != null && json['bookings'] is Map) {
      mappedJson['booking_code'] = json['bookings']['booking_code'];
    }
    if (json['venues'] != null && json['venues'] is Map) {
      mappedJson['venue_name'] = json['venues']['name'];
    }
    return _$SupportTicketModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ──────────────────────────────────────────────────────────────────────────
// reports model
// ──────────────────────────────────────────────────────────────────────────
@freezed
abstract class ReportModel with _$ReportModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ReportModel({
    required String id,
    required String reporterId,
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? description,
    required DateTime createdAt,
  }) = _ReportModel;

  const ReportModel._();

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ──────────────────────────────────────────────────────────────────────────
// user_sport_preferences model
// ──────────────────────────────────────────────────────────────────────────
@freezed
abstract class SportPreferenceModel with _$SportPreferenceModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SportPreferenceModel({
    required String id,
    required String userProfileId,
    required String sportType,
    @Default(1) int skillLevel,
  }) = _SportPreferenceModel;

  const SportPreferenceModel._();

  factory SportPreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$SportPreferenceModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ──────────────────────────────────────────────────────────────────────────
// user_profiles model
// ──────────────────────────────────────────────────────────────────────────
@freezed
abstract class UserProfileModel with _$UserProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory UserProfileModel({
    required String id,
    required String userId,
    String? bio,
    String? address,
    String? city,
    String? district,
    String? referralCode,
    String? referredById,
    @Default(true) bool isProfilePublic,
    @Default(true) bool notifPush,
    @Default(true) bool notifEmail,
    @Default(false) bool notifSms,
    @Default(true) bool notifBooking,
    @Default(true) bool notifPromotion,
    @Default(true) bool notifPayment,
    @Default(true) bool notifSystem,
    @Default(true) bool notifStaff,
    @Default([]) List<SportPreferenceModel> sportPreferences,
  }) = _UserProfileModel;

  const UserProfileModel._();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ──────────────────────────────────────────────────────────────────────────
// Full user model
// ──────────────────────────────────────────────────────────────────────────
@freezed
abstract class UserModel with _$UserModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    String? phone,
    String? avatarUrl,
    Gender? gender,
    DateTime? dateOfBirth,
    @Default(KycStatus.UNVERIFIED) KycStatus kycStatus,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isPhoneVerified,
    DateTime? lastLoginAt,
    UserProfileModel? profile,
    required DateTime createdAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson();
}
