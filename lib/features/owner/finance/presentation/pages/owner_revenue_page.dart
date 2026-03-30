import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/cubit/owner_revenue_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_commission_card.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_month_card.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_monthly_chart.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_payout_card.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-11: Doanh Thu & Hoa Hồng
// DB: commission_records, wallets, payout_requests, payout_bank_accounts
// ══════════════════════════════════════════════════════════════════════════════
class OwnerRevenuePage extends StatelessWidget {
  final String? venueId;
  const OwnerRevenuePage({super.key, this.venueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OwnerRevenueCubit>(
      create: (_) => getIt<OwnerRevenueCubit>()..initFinance(venueId),
      child: const _OwnerRevenueView(),
    );
  }
}

class _OwnerRevenueView extends StatefulWidget {
  const _OwnerRevenueView();

  @override
  State<_OwnerRevenueView> createState() => _OwnerRevenueViewState();
}

class _OwnerRevenueViewState extends State<_OwnerRevenueView> with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF1565C0);

  late TabController _tabCtrl;
  CommissionStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OwnerRevenueCubit, BaseState<OwnerRevenueState>>(
      listenWhen: (prev, curr) => curr.isSuccess || curr.isFailure,
      listener: (context, state) {
        if (state.isFailure && state.error != null) {
          getIt<ToastService>().error(state.error!);
        } else if (state.isSuccess && state.message != null) {
          getIt<ToastService>().success(state.message!);
        }
      },
      child: BlocBuilder<OwnerRevenueCubit, BaseState<OwnerRevenueState>>(
        builder: (context, state) {
          final data = state.data ?? const OwnerRevenueState();
          final wallet = data.wallet;
          final summaries = data.monthlySummaries;
          final commissions = data.commissions;
          final payouts = data.payouts;

          final filteredCommissions = _statusFilter == null
              ? commissions
              : commissions.where((r) => r.status == _statusFilter).toList();

          final double totalPending = commissions
              .where((r) => r.status == CommissionStatus.PENDING || r.status == CommissionStatus.APPROVED)
              .fold(0.0, (sum, r) => sum + r.ownerReceives);
          final double totalPaid = commissions
              .where((r) => r.status == CommissionStatus.PAID)
              .fold(0.0, (sum, r) => sum + r.ownerReceives);

          if (state.isLoading && !state.hasData) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF2F4F8),
            body: RefreshIndicator(
              onRefresh: () => context.read<OwnerRevenueCubit>().initFinance(null),
              child: NestedScrollView(
                headerSliverBuilder: (_, __) => [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 230,
                    backgroundColor: _brand,
                    automaticallyImplyLeading: true,
                    iconTheme: const IconThemeData(color: Colors.white),
                    centerTitle: false,
                    title: const Text('Báo cáo doanh thu',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white70),
                        onPressed: wallet != null ? () => _showPayoutSheet(context, wallet) : null,
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_brandDark, _brand],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const SizedBox(height: 38),
                              const SizedBox(height: 2),
                              if (wallet != null)
                                RevenueWalletCard(
                                  wallet: wallet,
                                  pendingAmount: totalPending,
                                  paidAmount: totalPaid,
                                  onPayout: () => _showPayoutSheet(context, wallet),
                                )
                              else
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                                  child: const Center(child: Text('Đang tải dữ liệu ví...', style: TextStyle(color: Colors.white70))),
                                ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    bottom: TabBar(
                      controller: _tabCtrl,
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      tabs: const [Tab(text: 'Theo Tháng'), Tab(text: 'Chi Tiết'), Tab(text: 'Rút Tiền')],
                    ),
                  ),
                ],
                body: TabBarView(controller: _tabCtrl, children: [
                  // ── Tab 1: Monthly summary ──
                  ListView(padding: const EdgeInsets.all(12), children: [
                    if (summaries.isNotEmpty) RevenueMonthlyChart(summaries: summaries) else const SizedBox(height: 150, child: Center(child: Text('Chưa có dữ liệu biểu đồ'))),
                    ...summaries.map((s) => RevenueMonthCard(summary: s)),
                  ]),
                  // ── Tab 2: Commission records ──
                  Column(children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            _FChip('Tất cả', _statusFilter == null,
                                () => setState(() => _statusFilter = null)),
                            ...CommissionStatus.values.map((s) => _FChip(s.label, _statusFilter == s,
                                () => setState(() => _statusFilter = _statusFilter == s ? null : s))),
                          ])),
                    ),
                    Expanded(
                        child: filteredCommissions.isEmpty
                            ? const Center(
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textHint),
                                SizedBox(height: 8),
                                Text('Không có dữ liệu', style: TextStyle(color: AppColors.textHint))
                              ]))
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: filteredCommissions.length,
                                itemBuilder: (_, i) => RevenueCommissionCard(record: filteredCommissions[i]))),
                  ]),
                  // ── Tab 3: Payout history ──
                  ListView(padding: const EdgeInsets.all(12), children: [
                    if (payouts.isEmpty)
                      const Center(
                          child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Column(children: [
                                Icon(Icons.account_balance_outlined, size: 48, color: AppColors.textHint),
                                SizedBox(height: 8),
                                Text('Chưa có yêu cầu rút tiền',
                                    style: TextStyle(color: AppColors.textHint))
                              ])))
                    else ...[
                      const Text('Lịch Sử Rút Tiền',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textHint)),
                      const SizedBox(height: 8),
                      ...payouts.map((p) => RevenuePayoutCard(payout: p)),
                    ],
                  ]),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPayoutSheet(BuildContext context, WalletModel wallet) {
    if (wallet.bankAccounts.isEmpty) {
      getIt<ToastService>().error('Vui lòng thêm tài khoản ngân hàng trước');
      return;
    }

    final amtCtrl = TextEditingController();
    BankAccountModel? selectedBank = wallet.bankAccounts
        .firstWhere((b) => b.isDefault, orElse: () => wallet.bankAccounts.first);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
          builder: (ctx, ss) => Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(2)))),
                          const SizedBox(height: 14),
                          const Row(children: [
                            Icon(Icons.upload_rounded, color: Color(0xFF0891B2)),
                            SizedBox(width: 8),
                            Text('Yêu Cầu Rút Tiền',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                          ]),
                          const SizedBox(height: 4),
                          Text('Số dư khả dụng: ${_fmtVnd(wallet.availableBalance)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                          const SizedBox(height: 16),
                          // Bank selector
                          const Text('Tài khoản nhận tiền',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...wallet.bankAccounts.map((b) => GestureDetector(
                                onTap: () => ss(() => selectedBank = b),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: selectedBank?.id == b.id
                                          ? const Color(0xFF0891B2).withValues(alpha: 0.05)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: selectedBank?.id == b.id
                                              ? const Color(0xFF0891B2)
                                              : AppColors.borderLight)),
                                  child: Row(children: [
                                    Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF0891B2).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8)),
                                        child: const Center(
                                            child: Icon(Icons.account_balance_rounded,
                                                size: 18, color: Color(0xFF0891B2)))),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                          Text(b.bankName,
                                              style: const TextStyle(
                                                  fontSize: 12, fontWeight: FontWeight.bold)),
                                          Text('${b.maskedAccount} · ${b.accountName}',
                                              style: const TextStyle(
                                                  fontSize: 10, color: AppColors.textHint)),
                                        ])),
                                    if (b.isDefault)
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: AppColors.success.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(6)),
                                          child: const Text('Mặc định',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: AppColors.success,
                                                  fontWeight: FontWeight.bold))),
                                    if (selectedBank?.id == b.id)
                                      const Icon(Icons.check_circle_rounded,
                                          color: Color(0xFF0891B2), size: 18),
                                  ]),
                                ),
                              )),
                          const SizedBox(height: 10),
                          TextField(
                            controller: amtCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Số tiền rút (đ) *',
                                prefixIcon: const Icon(Icons.monetization_on_outlined),
                                suffixText: 'đ',
                                border:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            _quickAmt('500K', 500000, amtCtrl, ss),
                            const SizedBox(width: 6),
                            _quickAmt('1M', 1000000, amtCtrl, ss),
                            const SizedBox(width: 6),
                            _quickAmt('5M', 5000000, amtCtrl, ss),
                            const SizedBox(width: 6),
                            GestureDetector(
                                onTap: () => ss(() =>
                                    amtCtrl.text = wallet.availableBalance.toInt().toString()),
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.info.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Tất cả',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.info)))),
                          ]),
                          const SizedBox(height: 16),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  final amtString = amtCtrl.text.replaceAll(',', '').replaceAll('.', '');
                                  final amt = double.tryParse(amtString) ?? 0;
                                  if (amt <= 0 ||
                                      amt > wallet.availableBalance ||
                                      selectedBank == null) {
                                      getIt<ToastService>().error('Số tiền không hợp lệ');
                                      return;
                                  }
                                  
                                  context.read<OwnerRevenueCubit>().createPayoutRequest(amt, selectedBank!.id);
                                  Navigator.pop(ctx);
                                  HapticFeedback.mediumImpact();
                                  _tabCtrl.animateTo(2);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0891B2),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 13),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))),
                                child: const Text('Gửi Yêu Cầu Rút Tiền',
                                    style: TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold)),
                              )),
                        ])),
              )),
    );
  }

  String _fmtVnd(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M đ';
    if (v >= 1000) return '${(v / 1000).round()}K đ';
    return '${v.toStringAsFixed(0)} đ';
  }
}

class _FChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FChip(this.label, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: selected ? const Color(0xFF0891B2) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: selected ? const Color(0xFF0891B2) : AppColors.borderLight)),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.textSecondary))));
}

Widget _quickAmt(String label, int amount, TextEditingController ctrl, StateSetter ss) =>
    GestureDetector(
        onTap: () => ss(() => ctrl.text = amount.toString()),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0xFF0891B2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(label,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))));
