import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/presentation/providers/invoice_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/invoice_card.dart';
import '../widgets/invoice_detail_view.dart';
import '../widgets/invoice_filter_chip.dart';

class InvoiceListPage extends HookConsumerWidget {
  const InvoiceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final filterStatus = useState<InvoiceStatus?>(null);

    final state = ref.watch(invoiceProvider);
    final notifier = ref.read(invoiceProvider.notifier);

    useAsyncValueListener(provider: invoiceProvider, ref: ref);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Hóa đơn',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ),
      body: switch (state) {
        AsyncData(:final value) => Column(
            children: [
              _buildFilters(filterStatus),
              const SizedBox(height: 8),
              Expanded(
                child: () {
                  final filtered = filterStatus.value == null
                      ? value
                      : value.where((i) => i.status == filterStatus.value).toList();
                  return filtered.isEmpty
                      ? _buildEmpty(isFiltered: filterStatus.value != null)
                      : _buildList(context, filtered, fmt);
                }(),
              ),
            ],
          ),
        AsyncError(:final error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text('$error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: notifier.refresh,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildFilters(ValueNotifier<InvoiceStatus?> filterStatus) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InvoiceFilterChip(
              label: 'Tất cả',
              selected: filterStatus.value == null,
              onTap: () => filterStatus.value = null,
            ),
            const SizedBox(width: 8),
            ...InvoiceStatus.values.map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InvoiceFilterChip(
                    label: s.label,
                    selected: filterStatus.value == s,
                    onTap: () => filterStatus.value = s,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<InvoiceModel> list,
    NumberFormat fmt,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (ctx, i) => InvoiceCard(
        invoice: list[i],
        fmt: fmt,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InvoiceDetailView(invoice: list[i], fmt: fmt),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty({bool isFiltered = false}) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded,
                size: 64,
                color: AppColors.primaryLightBrand.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(
              isFiltered ? 'Không tìm thấy hóa đơn phù hợp' : 'Chưa có hóa đơn',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
}
