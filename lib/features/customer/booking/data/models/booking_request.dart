import 'package:freezed_annotation/freezed_annotation.dart';
import 'booking_models.dart';

part 'booking_request.freezed.dart';
part 'booking_request.g.dart';

double _parsePrice(dynamic val) {
  if (val == null) return 0;
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0;
  return 0;
}

@freezed
abstract class BookingItemRequest with _$BookingItemRequest {
  const factory BookingItemRequest({
    @JsonKey(name: 'court_id') required String courtId,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
  }) = _BookingItemRequest;

  factory BookingItemRequest.fromJson(Map<String, dynamic> json) => _$BookingItemRequestFromJson(json);
}

@freezed
abstract class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'booking_date') required String bookingDate,
    required List<BookingItemRequest> items,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'voucher_code') String? voucherCode,
    String? note,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateBookingRequestFromJson(json);
}

@freezed
abstract class BookingAddonResponse with _$BookingAddonResponse {
  const factory BookingAddonResponse({
    required String id,
    @JsonKey(name: 'service_name') required String serviceName,
    required int quantity,
    @JsonKey(name: 'total_price', fromJson: _parsePrice) required double totalPrice,
  }) = _BookingAddonResponse;

  factory BookingAddonResponse.fromJson(Map<String, dynamic> json) => _$BookingAddonResponseFromJson(json);
}

@freezed
abstract class BookingResponse with _$BookingResponse {
  const factory BookingResponse({
    required String id,
    @JsonKey(name: 'booking_code') required String bookingCode,
    @JsonKey(name: 'check_in_code') String? checkInCode,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'court_id') required String courtId,
    @JsonKey(name: 'booking_date') required String bookingDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'total_amount', fromJson: _parsePrice) required double totalAmount,
    @JsonKey(name: 'sub_total', fromJson: _parsePrice) double? subTotal,
    @JsonKey(name: 'deposit_amount', fromJson: _parsePrice) double? depositAmount,
    @JsonKey(name: 'status') required BookingStatus status,
    @JsonKey(name: 'payment_status') required PaymentStatus paymentStatus,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'has_review') bool? hasReview,
    @Default([]) List<BookingAddonResponse> addons,
    // Nested objects from backend relations
    Map<String, dynamic>? venues,
    Map<String, dynamic>? courts,
  }) = _BookingResponse;

  factory BookingResponse.fromJson(Map<String, dynamic> json) => _$BookingResponseFromJson(json);
}

extension BookingResponseX on BookingResponse {
  String get venueName => this.venues?['name']?.toString() ?? 'Sân vận động';
  String get courtName => this.courts?['name']?.toString() ?? 'Sân';
  String get venueAddress => this.venues?['address']?.toString() ?? '';
}

@freezed
abstract class CreateBookingResponse with _$CreateBookingResponse {
  const factory CreateBookingResponse({
    required String message,
    required List<BookingResponse> bookings,
  }) = _CreateBookingResponse;

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) => _$CreateBookingResponseFromJson(json);
}

@freezed
abstract class ReviewRequest with _$ReviewRequest {
  const factory ReviewRequest({
    @JsonKey(name: 'booking_id') required String bookingId,
    required int rating,
    @JsonKey(name: 'rating_cleanliness') int? ratingCleanliness,
    @JsonKey(name: 'rating_facilities') int? ratingFacilities,
    @JsonKey(name: 'rating_staff') int? ratingStaff,
    String? comment,
    List<String>? images,
    List<String>? videos,
  }) = _ReviewRequest;

  factory ReviewRequest.fromJson(Map<String, dynamic> json) => _$ReviewRequestFromJson(json);
}

@freezed
abstract class FileUploadResponse with _$FileUploadResponse {
  const factory FileUploadResponse({
    required String url,
  }) = _FileUploadResponse;

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) => _$FileUploadResponseFromJson(json);
}
