import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

// ── Enums (schema.prisma) ──────────────────────────────────────────────────

enum InvoiceStatus {
  ISSUED,
  PAID,
  VOID,
  REFUNDED;

  String get label {
    switch (this) {
      case ISSUED:
        return 'Đã phát hành';
      case PAID:
        return 'Đã thanh toán';
      case VOID:
        return 'Đã hủy';
      case REFUNDED:
        return 'Đã hoàn tiền';
    }
  }
}

enum InvoiceItemType {
  COURT,
  ADDON,
  VAT,
  DISCOUNT;

  String get label {
    switch (this) {
      case COURT:
        return 'Tiền sân';
      case ADDON:
        return 'Dịch vụ';
      case VAT:
        return 'Thuế VAT';
      case DISCOUNT:
        return 'Giảm giá';
    }
  }
}

// ── invoice_items model ────────────────────────────────────────────────────
@freezed
abstract class InvoiceItemModel with _$InvoiceItemModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory InvoiceItemModel({
    required String id,
    required String invoiceId,
    required InvoiceItemType itemType,
    String? referenceId,
    required String name,
    required int quantity,
    required double unitPrice,
    required double subtotal,
    required double taxAmount,
    required double totalAmount,
  }) = _InvoiceItemModel;

  const InvoiceItemModel._();

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── invoices model ─────────────────────────────────────────────────────────
@freezed
abstract class InvoiceModel with _$InvoiceModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory InvoiceModel({
    required String id,
    required String invoiceNumber,
    required String bookingId,
    String? bookingCode,
    required String customerId,
    required double amount,
    required double taxAmount,
    required InvoiceStatus status,
    required DateTime issuedAt,
    String? pdfUrl,
    @Default([]) List<InvoiceItemModel> items,

    // Từ bookings join
    String? venueName,
    String? courtName,
    DateTime? bookingDate,
  }) = _InvoiceModel;

  const InvoiceModel._();

  double get totalWithTax => amount + taxAmount;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);

    // Handling join data from 'bookings' key if present
    if (json['bookings'] != null && json['bookings'] is Map) {
      mappedJson['booking_code'] = json['bookings']['booking_code'];
      mappedJson['booking_date'] = json['bookings']['booking_date'];
      if (json['bookings']['courts'] != null &&
          json['bookings']['courts'] is Map) {
        mappedJson['court_name'] = json['bookings']['courts']['name'];
        if (json['bookings']['courts']['venues'] != null &&
            json['bookings']['courts']['venues'] is Map) {
          mappedJson['venue_name'] = json['bookings']['courts']['venues']['name'];
        }
      }
    }

    // Mapping 'invoice_items' to 'items' for our model
    if (json['invoice_items'] != null) {
      mappedJson['items'] = json['invoice_items'];
    }

    return _$InvoiceModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}
