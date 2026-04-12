import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/presentation/cubit/invoice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';
import '../widgets/invoice_card.dart';
import '../widgets/invoice_filter_chip.dart';
import '../widgets/invoice_detail_view.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  InvoiceStatus? _filterStatus;

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
          onPressed: () => context.pop(),
        ),
        title: const Text('Hóa đơn',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ),
      body: BlocBuilder<InvoiceCubit, BaseState<List<InvoiceModel>>>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message ?? 'Đã có lỗi xảy ra'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<InvoiceCubit>().fetchInvoices(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final invoices = state.data ?? [];
          final filtered = _filterStatus == null
              ? invoices
              : invoices.where((i) => i.status == _filterStatus).toList();

          return Column(
            children: [
              _buildFilters(),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty(isFiltered: _filterStatus != null)
                    : _buildList(filtered),
              ),
            ],
          );
        },
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

  Widget _buildList(List<InvoiceModel> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (ctx, i) => InvoiceCard(
        invoice: list[i],
        fmt: fmt,
        onTap: () => _showDetail(context, list[i]),
      ),
    );
  }

  void _showDetail(BuildContext context, InvoiceModel inv) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => InvoiceDetailView(invoice: inv, fmt: fmt),
    ));
  }

  Widget _buildEmpty({bool isFiltered = false}) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded,
                size: 64, color: AppColors.primaryLightBrand.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(isFiltered ? 'Không tìm thấy hóa đơn phù hợp' : 'Chưa có hóa đơn',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary)),
          ],
        ),
      );
}
