import 'package:equatable/equatable.dart';

// ── Enums (schema.prisma) ──────────────────────────────────────────────────

enum InvoiceStatus {
  ISSUED,
  PAID,
  VOID,
  REFUNDED;

  String get label {
    switch (this) {
      case ISSUED: return 'Đã phát hành';
      case PAID: return 'Đã thanh toán';
      case VOID: return 'Đã hủy';
      case REFUNDED: return 'Đã hoàn tiền';
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
      case COURT: return 'Tiền sân';
      case ADDON: return 'Dịch vụ';
      case VAT: return 'Thuế VAT';
      case DISCOUNT: return 'Giảm giá';
    }
  }
}

// ── invoice_items model ────────────────────────────────────────────────────
class InvoiceItemModel extends Equatable {
  final String id;
  final String invoiceId;
  final InvoiceItemType itemType;
  final String? referenceId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final double taxAmount;
  final double totalAmount;

  const InvoiceItemModel({
    required this.id,
    required this.invoiceId,
    required this.itemType,
    this.referenceId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      InvoiceItemModel(
        id: json['id'],
        invoiceId: json['invoice_id'],
        itemType: InvoiceItemType.values.firstWhere(
            (e) => e.name == json['item_type']),
        referenceId: json['reference_id'],
        name: json['name'],
        quantity: json['quantity'] ?? 1,
        unitPrice: (json['unit_price'] as num).toDouble(),
        subtotal: (json['subtotal'] as num).toDouble(),
        taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
        totalAmount: (json['total_amount'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [id, itemType, totalAmount];
}

// ── invoices model ─────────────────────────────────────────────────────────
class InvoiceModel extends Equatable {
  final String id;
  final String invoiceNumber;
  final String bookingId;
  final String? bookingCode;
  final String customerId;
  final double amount;
  final double taxAmount;
  final InvoiceStatus status;
  final DateTime issuedAt;
  final String? pdfUrl;
  final List<InvoiceItemModel> items;

  // Từ bookings join
  final String? venueName;
  final String? courtName;
  final DateTime? bookingDate;

  const InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.bookingId,
    this.bookingCode,
    required this.customerId,
    required this.amount,
    required this.taxAmount,
    required this.status,
    required this.issuedAt,
    this.pdfUrl,
    this.items = const [],
    this.venueName,
    this.courtName,
    this.bookingDate,
  });

  double get totalWithTax => amount + taxAmount;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'],
        invoiceNumber: json['invoice_number'],
        bookingId: json['booking_id'],
        bookingCode: json['bookings']?['booking_code'],
        customerId: json['customer_id'],
        amount: (json['amount'] as num).toDouble(),
        taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
        status: InvoiceStatus.values.firstWhere(
            (e) => e.name == json['status']),
        issuedAt: DateTime.parse(json['issued_at']),
        pdfUrl: json['pdf_url'],
        items: (json['invoice_items'] as List? ?? [])
            .map((i) => InvoiceItemModel.fromJson(i))
            .toList(),
        venueName: json['bookings']?['courts']?['venues']?['name'],
        courtName: json['bookings']?['courts']?['name'],
        bookingDate: json['bookings']?['booking_date'] != null
            ? DateTime.parse(json['bookings']['booking_date'])
            : null,
      );

  @override
  List<Object?> get props => [id, invoiceNumber, status];
}
