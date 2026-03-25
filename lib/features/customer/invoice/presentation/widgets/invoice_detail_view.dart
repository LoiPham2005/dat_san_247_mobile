import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';

class InvoiceDetailView extends StatelessWidget {
  final InvoiceModel invoice;
  final NumberFormat fmt;

  const InvoiceDetailView({
    super.key,
    required this.invoice,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context)),
        title: Text(invoice.invoiceNumber,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 0.3)),
        actions: [
          if (invoice.pdfUrl != null)
            IconButton(
              icon: const Icon(Icons.download_rounded,
                  color: AppColors.primaryLightBrand),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⬇️ Đang tải PDF hóa đơn...'))),
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
                gradient: const LinearGradient(
                    colors: [Color(0xFF0F7A35), Color(0xFF22C55E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.receipt_long_rounded,
                      color: AppColors.white, size: 36),
                  const SizedBox(height: 8),
                  Text(fmt.format(invoice.amount),
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(invoice.status.label,
                      style: const TextStyle(color: AppColors.white70, fontSize: 13)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: invoice.invoiceNumber));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('📋 Đã sao chép số hóa đơn'),
                          duration: Duration(seconds: 1)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(invoice.invoiceNumber,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1)),
                        const SizedBox(width: 6),
                        const Icon(Icons.copy_rounded,
                            color: AppColors.white70, size: 14),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Venue info ──
            _InfoCard(children: [
              _InfoRow(
                  label: 'Địa điểm',
                  value: '${invoice.courtName} · ${invoice.venueName}'),
              if (invoice.bookingDate != null)
                _InfoRow(
                    label: 'Ngày bookings',
                    value: DateFormat('dd/MM/yyyy').format(invoice.bookingDate!)),
              _InfoRow(label: 'Mã booking', value: invoice.bookingCode ?? '—'),
              _InfoRow(
                  label: 'Phát hành',
                  value: DateFormat('HH:mm dd/MM/yyyy').format(invoice.issuedAt)),
            ]),
            const SizedBox(height: 14),

            // ── Line items ──
            if (invoice.items.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.black.withOpacity(0.04),
                          blurRadius: 8)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chi tiết dịch vụ',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...invoice.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    color: _itemColor(item.itemType)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(item.itemType.label,
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: _itemColor(item.itemType))),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(item.name,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textPrimary))),
                              Text(fmt.format(item.totalAmount),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: item.itemType ==
                                            InvoiceItemType.DISCOUNT
                                        ? AppColors.success
                                        : AppColors.textPrimary,
                                  )),
                            ],
                          ),
                        )),
                    const Divider(color: AppColors.borderLight),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng cộng',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(fmt.format(invoice.amount),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryLightBrand)),
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
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('⬇️ Đang tải PDF hóa đơn...'))),
                  icon: const Icon(Icons.picture_as_pdf_rounded,
                      color: AppColors.white, size: 18),
                  label: const Text('Tải hóa đơn PDF',
                      style: TextStyle(
                          color: AppColors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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
      case InvoiceItemType.COURT:
        return AppColors.primaryLightBrand;
      case InvoiceItemType.ADDON:
        return AppColors.info;
      case InvoiceItemType.VAT:
        return AppColors.warning;
      case InvoiceItemType.DISCOUNT:
        return AppColors.success;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)
            ]),
        child: Column(children: children),
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            Flexible(
                child: Text(value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary))),
          ],
        ),
      );
}
