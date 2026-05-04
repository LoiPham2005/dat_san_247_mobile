// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

enum InvoiceStatus {
  @JsonValue('DRAFT')
  DRAFT,
  @JsonValue('ISSUED')
  ISSUED,
  @JsonValue('PAID')
  PAID,
  @JsonValue('VOID')
  VOID,
  @JsonValue('REFUNDED')
  REFUNDED;

  String get label {
    return switch (this) {
      InvoiceStatus.DRAFT => 'Nháp',
      InvoiceStatus.ISSUED => 'Chờ thanh toán',
      InvoiceStatus.PAID => 'Đã thanh toán',
      InvoiceStatus.VOID => 'Đã hủy',
      InvoiceStatus.REFUNDED => 'Đã hoàn trả',
    };
  }
}

enum InvoiceItemType {
  @JsonValue('COURT')
  COURT,
  @JsonValue('ADDON')
  ADDON,
  @JsonValue('VAT')
  VAT,
  @JsonValue('DISCOUNT')
  DISCOUNT;

  String get label {
    return switch (this) {
      InvoiceItemType.COURT => 'Tiền sân',
      InvoiceItemType.ADDON => 'Dịch vụ',
      InvoiceItemType.VAT => 'Thuế VAT',
      InvoiceItemType.DISCOUNT => 'Giảm giá',
    };
  }
}

@freezed
abstract class InvoiceModel with _$InvoiceModel {
  const factory InvoiceModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'transaction_id') required String transactionId,
    required double amount,
    required InvoiceStatus status,
    @JsonKey(name: 'issued_at') required DateTime issuedAt,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    required BookingInfoModel bookings,
    @Default([]) List<InvoiceItemModel> items,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => _$InvoiceModelFromJson(json);
}

@freezed
abstract class BookingInfoModel with _$BookingInfoModel {
  const factory BookingInfoModel({
    @JsonKey(name: 'booking_code') required String bookingCode,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    required VenueSimpleInfo venues,
  }) = _BookingInfoModel;

  factory BookingInfoModel.fromJson(Map<String, dynamic> json) => _$BookingInfoModelFromJson(json);
}

@freezed
abstract class VenueSimpleInfo with _$VenueSimpleInfo {
  const factory VenueSimpleInfo({
    required String name,
  }) = _VenueSimpleInfo;

  factory VenueSimpleInfo.fromJson(Map<String, dynamic> json) => _$VenueSimpleInfoFromJson(json);
}

@freezed
abstract class InvoiceItemModel with _$InvoiceItemModel {
  const factory InvoiceItemModel({
    required String id,
    required String name,
    required int quantity,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'item_type') required InvoiceItemType itemType,
  }) = _InvoiceItemModel;

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) => _$InvoiceItemModelFromJson(json);
}
