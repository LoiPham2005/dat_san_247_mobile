import 'package:equatable/equatable.dart';

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
class TicketMessageModel extends Equatable {
  final String id;
  final String ticketId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String message;
  final bool isStaff;
  final String? attachmentUrl;
  final DateTime createdAt;

  const TicketMessageModel({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.message,
    required this.isStaff,
    this.attachmentUrl,
    required this.createdAt,
  });

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) =>
      TicketMessageModel(
        id: json['id'],
        ticketId: json['ticket_id'],
        senderId: json['sender_id'],
        senderName: json['users']?['full_name'] ?? 'Unknown',
        senderAvatar: json['users']?['avatar_url'],
        message: json['message'],
        isStaff: json['is_staff'] ?? false,
        attachmentUrl: json['attachment_url'],
        createdAt: DateTime.parse(json['created_at']),
      );

  @override
  List<Object?> get props => [id, isStaff, createdAt];
}

// ──────────────────────────────────────────────────────────────────────────
// support_tickets model
// ──────────────────────────────────────────────────────────────────────────
class SupportTicketModel extends Equatable {
  final String id;
  final String ticketNumber;
  final String customerId;
  final SupportTicketCategory category;
  final SupportTicketPriority priority;
  final SupportTicketStatus status;
  final String subject;
  final String description;
  final String? bookingId;
  final String? bookingCode;
  final String? venueId;
  final String? venueName;
  final String? resolution;
  final DateTime? resolvedAt;
  final DateTime? firstResponseAt;
  final int? customerRating;
  final String? customerFeedback;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TicketMessageModel> messages;

  const SupportTicketModel({
    required this.id,
    required this.ticketNumber,
    required this.customerId,
    required this.category,
    required this.priority,
    required this.status,
    required this.subject,
    required this.description,
    this.bookingId,
    this.bookingCode,
    this.venueId,
    this.venueName,
    this.resolution,
    this.resolvedAt,
    this.firstResponseAt,
    this.customerRating,
    this.customerFeedback,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      SupportTicketModel(
        id: json['id'],
        ticketNumber: json['ticket_number'],
        customerId: json['customer_id'],
        category: SupportTicketCategory.values.firstWhere(
            (e) => e.name == json['category'],
            orElse: () => SupportTicketCategory.OTHER),
        priority: SupportTicketPriority.values.firstWhere(
            (e) => e.name == json['priority'],
            orElse: () => SupportTicketPriority.MEDIUM),
        status: SupportTicketStatus.values.firstWhere(
            (e) => e.name == json['status'],
            orElse: () => SupportTicketStatus.OPEN),
        subject: json['subject'],
        description: json['description'],
        bookingId: json['booking_id'],
        bookingCode: json['bookings']?['booking_code'],
        venueId: json['venue_id'],
        venueName: json['venues']?['name'],
        resolution: json['resolution'],
        resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at']) : null,
        firstResponseAt: json['first_response_at'] != null ? DateTime.parse(json['first_response_at']) : null,
        customerRating: json['customer_rating'],
        customerFeedback: json['customer_feedback'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        messages: (json['messages'] as List? ?? [])
            .map((m) => TicketMessageModel.fromJson(m))
            .toList(),
      );

  @override
  List<Object?> get props => [id, status, ticketNumber];
}

// ──────────────────────────────────────────────────────────────────────────
// reports model
// ──────────────────────────────────────────────────────────────────────────
class ReportModel extends Equatable {
  final String id;
  final String reporterId;
  final ReportTargetType targetType;
  final String targetId;
  final ReportReason reason;
  final String? description;
  final DateTime createdAt;

  const ReportModel({
    required this.id,
    required this.reporterId,
    required this.targetType,
    required this.targetId,
    required this.reason,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'reporter_id': reporterId,
        'target_type': targetType.name,
        'target_id': targetId,
        'reason': reason.name,
        'description': description,
      };

  @override
  List<Object?> get props => [id, targetType, reason];
}

// ──────────────────────────────────────────────────────────────────────────
// user_sport_preferences model
// ──────────────────────────────────────────────────────────────────────────
class SportPreferenceModel extends Equatable {
  final String id;
  final String userProfileId;
  final String sportType;
  final int skillLevel; // 1-5

  const SportPreferenceModel({
    required this.id,
    required this.userProfileId,
    required this.sportType,
    required this.skillLevel,
  });

  factory SportPreferenceModel.fromJson(Map<String, dynamic> json) =>
      SportPreferenceModel(
        id: json['id'],
        userProfileId: json['user_profile_id'],
        sportType: json['sport_type'],
        skillLevel: json['skill_level'] ?? 1,
      );

  @override
  List<Object?> get props => [id, sportType, skillLevel];
}

// ──────────────────────────────────────────────────────────────────────────
// user_profiles model (notification prefs gộp vào đây theo schema)
// ──────────────────────────────────────────────────────────────────────────
class UserProfileModel extends Equatable {
  final String id;
  final String userId;
  final String? bio;
  final String? address;
  final String? city;
  final String? district;
  final String? referralCode;
  final String? referredById;
  final bool isProfilePublic;
  // Notification prefs (user_profiles fields)
  final bool notifPush;
  final bool notifEmail;
  final bool notifSms;
  final bool notifBooking;
  final bool notifPromotion;
  final bool notifPayment;
  final bool notifSystem;
  final bool notifStaff;
  final List<SportPreferenceModel> sportPreferences;

  const UserProfileModel({
    required this.id,
    required this.userId,
    this.bio,
    this.address,
    this.city,
    this.district,
    this.referralCode,
    this.referredById,
    this.isProfilePublic = true,
    this.notifPush = true,
    this.notifEmail = true,
    this.notifSms = false,
    this.notifBooking = true,
    this.notifPromotion = true,
    this.notifPayment = true,
    this.notifSystem = true,
    this.notifStaff = true,
    this.sportPreferences = const [],
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'],
        userId: json['user_id'],
        bio: json['bio'],
        address: json['address'],
        city: json['city'],
        district: json['district'],
        referralCode: json['referral_code'],
        referredById: json['referred_by_id'],
        isProfilePublic: json['is_profile_public'] ?? true,
        notifPush: json['notif_push'] ?? true,
        notifEmail: json['notif_email'] ?? true,
        notifSms: json['notif_sms'] ?? false,
        notifBooking: json['notif_booking'] ?? true,
        notifPromotion: json['notif_promotion'] ?? true,
        notifPayment: json['notif_payment'] ?? true,
        notifSystem: json['notif_system'] ?? true,
        notifStaff: json['notif_staff'] ?? true,
        sportPreferences: (json['sport_preferences'] as List? ?? [])
            .map((s) => SportPreferenceModel.fromJson(s))
            .toList(),
      );

  @override
  List<Object?> get props => [id, userId];
}

// ──────────────────────────────────────────────────────────────────────────
// Full user model (users + user_profiles joined)
// ──────────────────────────────────────────────────────────────────────────
class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final Gender? gender;
  final DateTime? dateOfBirth;
  final KycStatus kycStatus;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime? lastLoginAt;
  final UserProfileModel? profile;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    required this.kycStatus,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.lastLoginAt,
    this.profile,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        fullName: json['full_name'],
        phone: json['phone'],
        avatarUrl: json['avatar_url'],
        gender: json['gender'] != null
            ? Gender.values.firstWhere((e) => e.name == json['gender'])
            : null,
        dateOfBirth: json['date_of_birth'] != null
            ? DateTime.parse(json['date_of_birth'])
            : null,
        kycStatus: KycStatus.values.firstWhere(
            (e) => e.name == json['kyc_status'],
            orElse: () => KycStatus.UNVERIFIED),
        isEmailVerified: json['is_email_verified'] ?? false,
        isPhoneVerified: json['is_phone_verified'] ?? false,
        lastLoginAt: json['last_login_at'] != null
            ? DateTime.parse(json['last_login_at'])
            : null,
        profile: json['profile'] != null
            ? UserProfileModel.fromJson(json['profile'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
      );

  @override
  List<Object?> get props => [id, email, kycStatus];
}
