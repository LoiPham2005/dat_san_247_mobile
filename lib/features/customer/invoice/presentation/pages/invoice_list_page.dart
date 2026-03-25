import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';
import '../widgets/invoice_card.dart';
import '../widgets/invoice_filter_chip.dart';
import '../widgets/invoice_detail_view.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-16: Hóa Đơn
// ──────────────────────────────────────────────────────────────────────────
class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  final List<InvoiceModel> _invoices = [
    InvoiceModel(
      id: 'inv1', invoiceNumber: 'INV-2026-001', bookingId: 'b1', bookingCode: 'DS24701234',
      customerId: 'u1', amount: 150000, taxAmount: 0, status: InvoiceStatus.PAID,
      issuedAt: DateTime.now().subtract(const Duration(days: 1)),
      pdfUrl: 'https://example.com/invoice/inv1.pdf',
      venueName: 'Sân K34 Phạm Văn Đồng', courtName: 'Sân A - 5 người',
      bookingDate: DateTime.now().subtract(const Duration(days: 1)),
      items: [
        InvoiceItemModel(id: 'ii1', invoiceId: 'inv1', itemType: InvoiceItemType.COURT, name: 'Tiền sân – 60 phút', quantity: 1, unitPrice: 150000, subtotal: 150000, taxAmount: 0, totalAmount: 150000),
        InvoiceItemModel(id: 'ii2', invoiceId: 'inv1', itemType: InvoiceItemType.ADDON, name: 'Thuê áo đá bóng x2', quantity: 2, unitPrice: 30000, subtotal: 60000, taxAmount: 0, totalAmount: 60000),
      ],
    ),
    InvoiceModel(
      id: 'inv2', invoiceNumber: 'INV-2026-002', bookingId: 'b2', bookingCode: 'DS24799001',
      customerId: 'u1', amount: 300000, taxAmount: 0, status: InvoiceStatus.ISSUED,
      issuedAt: DateTime.now().subtract(const Duration(days: 5)),
      venueName: 'Sân Thể Thao Vạn Hạnh', courtName: 'Sân Cầu Lông B',
      bookingDate: DateTime.now().subtract(const Duration(days: 5)),
      items: [
        InvoiceItemModel(id: 'ii3', invoiceId: 'inv2', itemType: InvoiceItemType.COURT, name: 'Tiền sân – 90 phút', quantity: 1, unitPrice: 300000, subtotal: 300000, taxAmount: 0, totalAmount: 300000),
      ],
    ),
    InvoiceModel(
      id: 'inv3', invoiceNumber: 'INV-2025-089', bookingId: 'b3', bookingCode: 'DS24788002',
      customerId: 'u1', amount: 200000, taxAmount: 0, status: InvoiceStatus.REFUNDED,
      issuedAt: DateTime.now().subtract(const Duration(days: 20)),
      venueName: 'Sân K34 Phạm Văn Đồng', courtName: 'Sân B',
      bookingDate: DateTime.now().subtract(const Duration(days: 20)),
      items: [],
    ),
  ];

  InvoiceStatus? _filterStatus;

  List<InvoiceModel> get _filtered => _filterStatus == null
      ? _invoices
      : _invoices.where((i) => i.status == _filterStatus).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Hóa đơn',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          _buildFilters(),
          const SizedBox(height: 8),
          Expanded(
            child: _filtered.isEmpty ? _buildEmpty() : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InvoiceFilterChip(
                label: 'Tất cả',
                selected: _filterStatus == null,
                onTap: () => setState(() => _filterStatus = null)),
            const SizedBox(width: 8),
            ...InvoiceStatus.values.map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InvoiceFilterChip(
                      label: s.label,
                      selected: _filterStatus == s,
                      onTap: () => setState(() => _filterStatus = s)),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) => InvoiceCard(
        invoice: _filtered[i],
        fmt: fmt,
        onTap: () => _showDetail(context, _filtered[i]),
      ),
    );
  }

  void _showDetail(BuildContext context, InvoiceModel inv) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => InvoiceDetailView(invoice: inv, fmt: fmt),
    ));
  }

  Widget _buildEmpty() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 64, color: AppColors.primaryLightBrand),
            SizedBox(height: 12),
            const Text('Chưa có hóa đơn',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
