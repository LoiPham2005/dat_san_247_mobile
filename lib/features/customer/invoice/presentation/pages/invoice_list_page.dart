import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';

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
        title: const Text('Hóa đơn', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // ── Filter chips ──
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'Tất cả', selected: _filterStatus == null, onTap: () => setState(() => _filterStatus = null)),
                  const SizedBox(width: 8),
                  ...InvoiceStatus.values.map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(label: s.label, selected: _filterStatus == s, onTap: () => setState(() => _filterStatus = s)),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _InvoiceCard(
                      invoice: _filtered[i],
                      fmt: fmt,
                      onTap: () => _showDetail(context, _filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, InvoiceModel inv) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _InvoiceDetailPage(invoice: inv, fmt: fmt),
    ));
  }

  Widget _buildEmpty() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long_rounded, size: 64, color: AppColors.primaryLightBrand),
        SizedBox(height: 12),
        Text('Chưa có hóa đơn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// ──────────────────────────────────────────────────────────────────────────
// Invoice Card
// ──────────────────────────────────────────────────────────────────────────
class _InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final NumberFormat fmt;
  final VoidCallback onTap;
  const _InvoiceCard({required this.invoice, required this.fmt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (color, bg, icon) = _statusStyle(invoice.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(icon, size: 11, color: color),
                    const SizedBox(width: 4),
                    Text(invoice.status.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                  ]),
                ),
                const Spacer(),
                Text(invoice.invoiceNumber, style: const TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 10),
            Text('${invoice.courtName ?? '—'} · ${invoice.venueName ?? '—'}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
            if (invoice.bookingDate != null) ...[
              const SizedBox(height: 4),
              Text(DateFormat('dd/MM/yyyy').format(invoice.bookingDate!), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fmt.format(invoice.amount), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand)),
                Row(children: [
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color, IconData) _statusStyle(InvoiceStatus s) {
    switch (s) {
      case InvoiceStatus.ISSUED: return (AppColors.warning, AppColors.warning.withOpacity(0.12), Icons.receipt_outlined);
      case InvoiceStatus.PAID: return (AppColors.success, AppColors.success.withOpacity(0.1), Icons.check_circle_rounded);
      case InvoiceStatus.VOID: return (AppColors.textHint, AppColors.mutedLight, Icons.cancel_outlined);
      case InvoiceStatus.REFUNDED: return (AppColors.info, AppColors.info.withOpacity(0.1), Icons.undo_rounded);
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Invoice Detail Page
// ──────────────────────────────────────────────────────────────────────────
class _InvoiceDetailPage extends StatelessWidget {
  final InvoiceModel invoice;
  final NumberFormat fmt;
  const _InvoiceDetailPage({required this.invoice, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Text(invoice.invoiceNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 0.3)),
        actions: [
          if (invoice.pdfUrl != null)
            IconButton(
              icon: const Icon(Icons.download_rounded, color: AppColors.primaryLightBrand),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⬇️ Đang tải PDF hóa đơn...'))),
              tooltip: 'Tải PDF',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Header card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F7A35), Color(0xFF22C55E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.receipt_long_rounded, color: AppColors.white, size: 36),
                  const SizedBox(height: 8),
                  Text(fmt.format(invoice.amount), style: const TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(invoice.status.label, style: const TextStyle(color: AppColors.white70, fontSize: 13)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () { Clipboard.setData(ClipboardData(text: invoice.invoiceNumber)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📋 Đã sao chép số hóa đơn'), duration: Duration(seconds: 1))); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(invoice.invoiceNumber, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                        const SizedBox(width: 6),
                        const Icon(Icons.copy_rounded, color: AppColors.white70, size: 14),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Venue info ──
            _Card(children: [
              _Row(label: 'Địa điểm', value: '${invoice.courtName} · ${invoice.venueName}'),
              if (invoice.bookingDate != null) _Row(label: 'Ngày bookings', value: DateFormat('dd/MM/yyyy').format(invoice.bookingDate!)),
              _Row(label: 'Mã booking', value: invoice.bookingCode ?? '—'),
              _Row(label: 'Phát hành', value: DateFormat('HH:mm dd/MM/yyyy').format(invoice.issuedAt)),
            ]),
            const SizedBox(height: 14),

            // ── Line items ──
            if (invoice.items.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chi tiết dịch vụ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...invoice.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: _itemColor(item.itemType).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(item.itemType.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _itemColor(item.itemType))),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item.name, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
                          Text(fmt.format(item.totalAmount), style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold,
                            color: item.itemType == InvoiceItemType.DISCOUNT ? AppColors.success : AppColors.textPrimary,
                          )),
                        ],
                      ),
                    )),
                    const Divider(color: AppColors.borderLight),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(fmt.format(invoice.amount), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // ── Download PDF ──
            if (invoice.pdfUrl != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⬇️ Đang tải PDF hóa đơn...'))),
                  icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.white, size: 18),
                  label: const Text('Tải hóa đơn PDF', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand, elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _itemColor(InvoiceItemType t) {
    switch (t) {
      case InvoiceItemType.COURT: return AppColors.primaryLightBrand;
      case InvoiceItemType.ADDON: return AppColors.info;
      case InvoiceItemType.VAT: return AppColors.warning;
      case InvoiceItemType.DISCOUNT: return AppColors.success;
    }
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(children: children),
  );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
      ],
    ),
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: selected ? AppColors.primaryLightBrand : AppColors.mutedLight, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? AppColors.white : AppColors.textSecondary)),
    ),
  );
}
