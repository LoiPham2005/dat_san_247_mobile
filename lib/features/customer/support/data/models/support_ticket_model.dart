import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_ticket_model.freezed.dart';
part 'support_ticket_model.g.dart';

enum SupportTicketStatus {
  @JsonValue('OPEN')
  OPEN,
  @JsonValue('IN_PROGRESS')
  IN_PROGRESS,
  @JsonValue('RESOLVED')
  RESOLVED,
  @JsonValue('CLOSED')
  CLOSED;

  String get label {
    return switch (this) {
      SupportTicketStatus.OPEN => 'Mới',
      SupportTicketStatus.IN_PROGRESS => 'Đang xử lý',
      SupportTicketStatus.RESOLVED => 'Đã giải quyết',
      SupportTicketStatus.CLOSED => 'Đã đóng',
    };
  }
}

enum SupportTicketPriority {
  @JsonValue('LOW')
  LOW,
  @JsonValue('MEDIUM')
  MEDIUM,
  @JsonValue('HIGH')
  HIGH,
  @JsonValue('URGENT')
  URGENT;

  String get label {
    return switch (this) {
      SupportTicketPriority.LOW => 'Thấp',
      SupportTicketPriority.MEDIUM => 'Trung bình',
      SupportTicketPriority.HIGH => 'Cao',
      SupportTicketPriority.URGENT => 'Khẩn cấp',
    };
  }
}

enum SupportTicketCategory {
  @JsonValue('BOOKING')
  BOOKING,
  @JsonValue('PAYMENT')
  PAYMENT,
  @JsonValue('ACCOUNT')
  ACCOUNT,
  @JsonValue('APP_ISSUE')
  APP_ISSUE,
  @JsonValue('VENUE_ISSUE')
  VENUE_ISSUE,
  @JsonValue('OTHER')
  OTHER;

  String get label {
    return switch (this) {
      SupportTicketCategory.BOOKING => 'Đơn đặt sân',
      SupportTicketCategory.PAYMENT => 'Thanh toán',
      SupportTicketCategory.ACCOUNT => 'Tài khoản',
      SupportTicketCategory.APP_ISSUE => 'Lỗi ứng dụng',
      SupportTicketCategory.VENUE_ISSUE => 'Vấn đề cơ sở',
      SupportTicketCategory.OTHER => 'Khác',
    };
  }
}

@freezed
abstract class SupportTicketModel with _$SupportTicketModel {
  const SupportTicketModel._();

  const factory SupportTicketModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String subject,
    required String description,
    required SupportTicketStatus status,
    required SupportTicketPriority priority,
    required SupportTicketCategory category,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'venue_id') String? venueId,
    String? resolution,
    @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
    @JsonKey(name: 'closed_at') DateTime? closedAt,
  }) = _SupportTicketModel;

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) => _$SupportTicketModelFromJson(json);
}
