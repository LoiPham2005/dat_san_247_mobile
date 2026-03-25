import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_commission_card.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_month_card.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_monthly_chart.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_payout_card.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/widgets/revenue_wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-11: Doanh Thu & Hoa Hồng
// DB: commission_records, wallets, payout_requests, payout_bank_accounts
// ══════════════════════════════════════════════════════════════════════════════
class OwnerRevenuePage extends StatefulWidget {
  const OwnerRevenuePage({super.key});
  @override
  State<OwnerRevenuePage> createState() => _OwnerRevenuePageState();
}

class _OwnerRevenuePageState extends State<OwnerRevenuePage> with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF1565C0);

  late TabController _tabCtrl;
  CommissionStatus? _statusFilter;

  final _wallet = WalletModel(
    id: 'w1',
    userId: 'u1',
    balance: 12850000.0,
    lockedBalance: 1200000.0,
    isActive: true,
    updatedAt: DateTime.now(),
    bankAccounts: [
      const BankAccountModel(
          id: 'ba1',
          walletId: 'w1',
          bankName: 'Vietcombank',
          bankCode: 'VCB',
          accountNumber: '0011004123456',
          accountName: 'NGUYEN VAN AN',
          isDefault: true),
      const BankAccountModel(
          id: 'ba2',
          walletId: 'w1',
          bankName: 'Techcombank',
          bankCode: 'TCB',
          accountNumber: '19038876543210',
          accountName: 'NGUYEN VAN AN',
          isDefault: false),
    ],
  );

  final List<RevenueSummaryModel> _monthlySummary = _buildMonthlySummary();
  final List<CommissionRecordModel> _records = _buildRecords();
  final List<PayoutRequestModel> _payouts = _buildPayouts();

  static List<RevenueSummaryModel> _buildMonthlySummary() {
    final months = ['2026-03', '2026-02', '2026-01', '2025-12'];
    final data = [
      [28, 8400000.0, 840000.0, 7560000.0, 6300000.0, 1260000.0],
      [35, 10500000.0, 1050000.0, 9450000.0, 9450000.0, 0.0],
      [22, 6600000.0, 660000.0, 5940000.0, 5940000.0, 0.0],
      [40, 12000000.0, 1200000.0, 10800000.0, 10800000.0, 0.0],
    ];
    return List.generate(
        4,
        (i) => RevenueSummaryModel(
              month: months[i],
              bookingCount: data[i][0].toInt(),
              totalBookingAmount: data[i][1].toDouble(),
              totalCommissionAmount: data[i][2].toDouble(),
              totalOwnerReceives: data[i][3].toDouble(),
              paidAmount: data[i][4].toDouble(),
              pendingAmount: data[i][5].toDouble(),
            ));
  }

  static List<CommissionRecordModel> _buildRecords() {
    final now = DateTime.now();
    return [
      CommissionRecordModel(
          id: 'c1',
          bookingId: 'b1',
          bookingCode: 'DS24800101',
          venueId: 'v1',
          venueName: 'Sân Bóng ABC',
          ownerId: 'u1',
          bookingDate: now.subtract(const Duration(days: 1)),
          courtName: 'Sân A (5)',
          customerName: 'Nguyễn Văn An',
          bookingAmount: 300000,
          commissionRate: 10,
          commissionAmount: 30000,
          ownerReceives: 270000,
          status: CommissionStatus.PAID,
          paidAt: now.subtract(const Duration(hours: 6)),
          createdAt: now.subtract(const Duration(days: 1))),
      CommissionRecordModel(
          id: 'c2',
          bookingId: 'b2',
          bookingCode: 'DS24800102',
          venueId: 'v1',
          venueName: 'Sân Bóng ABC',
          ownerId: 'u1',
          bookingDate: now.subtract(const Duration(hours: 8)),
          courtName: 'Sân B (7)',
          customerName: 'Lê Thị Bình',
          bookingAmount: 400000,
          commissionRate: 10,
          commissionAmount: 40000,
          ownerReceives: 360000,
          status: CommissionStatus.APPROVED,
          createdAt: now.subtract(const Duration(hours: 8))),
      CommissionRecordModel(
          id: 'c3',
          bookingId: 'b3',
          bookingCode: 'DS24800103',
          venueId: 'v1',
          venueName: 'Sân Bóng ABC',
          ownerId: 'u1',
          bookingDate: now.subtract(const Duration(days: 2)),
          courtName: 'Sân Tennis',
          customerName: 'Phạm Quốc Cường',
          bookingAmount: 500000,
          commissionRate: 10,
          commissionAmount: 50000,
          ownerReceives: 450000,
          status: CommissionStatus.PAID,
          paidAt: now.subtract(const Duration(days: 1)),
          createdAt: now.subtract(const Duration(days: 2))),
      CommissionRecordModel(
          id: 'c4',
          bookingId: 'b4',
          bookingCode: 'DS24800104',
          venueId: 'v2',
          venueName: 'Sân Cầu Lông XYZ',
          ownerId: 'u1',
          bookingDate: now,
          courtName: 'Cầu Lông',
          customerName: 'Hoàng Minh Đức',
          bookingAmount: 200000,
          commissionRate: 10,
          commissionAmount: 20000,
          ownerReceives: 180000,
          status: CommissionStatus.PENDING,
          createdAt: now),
      CommissionRecordModel(
          id: 'c5',
          bookingId: 'b5',
          bookingCode: 'DS24800105',
          venueId: 'v1',
          venueName: 'Sân Bóng ABC',
          ownerId: 'u1',
          bookingDate: now.subtract(const Duration(days: 3)),
          courtName: 'Sân A (5)',
          customerName: 'Trần Văn Em',
          bookingAmount: 300000,
          commissionRate: 10,
          commissionAmount: 30000,
          ownerReceives: 270000,
          status: CommissionStatus.PAID,
          paidAt: now.subtract(const Duration(days: 2)),
          createdAt: now.subtract(const Duration(days: 3))),
    ];
  }

  static List<PayoutRequestModel> _buildPayouts() {
    final now = DateTime.now();
    return [
      PayoutRequestModel(
          id: 'pr1',
          userId: 'u1',
          amount: 5000000.0,
          status: PayoutStatus.COMPLETED,
          bankAccountId: 'ba1',
          bankAccountName: 'NGUYEN VAN AN',
          bankName: 'Vietcombank',
          processedAt: now.subtract(const Duration(days: 5)),
          createdAt: now.subtract(const Duration(days: 7))),
      PayoutRequestModel(
          id: 'pr2',
          userId: 'u1',
          amount: 3000000.0,
          status: PayoutStatus.PROCESSING,
          bankAccountId: 'ba1',
          bankAccountName: 'NGUYEN VAN AN',
          bankName: 'Techcombank',
          createdAt: now.subtract(const Duration(days: 1))),
    ];
  }

  List<CommissionRecordModel> get _filtered =>
      _statusFilter == null ? _records : _records.where((r) => r.status == _statusFilter).toList();

  double get _totalPending => _records
      .where((r) => r.status == CommissionStatus.PENDING || r.status == CommissionStatus.APPROVED)
      .fold(0.0, (sum, r) => sum + r.ownerReceives);
  double get _totalPaid => _records
      .where((r) => r.status == CommissionStatus.PAID)
      .fold(0.0, (sum, r) => sum + r.ownerReceives);

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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 230,
            backgroundColor: _brand,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: const Text('Báo cáo doanh thu',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            actions: [
              IconButton(
                icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white70),
                onPressed: () => _showPayoutSheet(context),
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
                      // const Text('Tài chính & Doanh thu',
                      //     style: TextStyle(
                      //         color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      RevenueWalletCard(
                        wallet: _wallet,
                        pendingAmount: _totalPending,
                        paidAmount: _totalPaid,
                        onPayout: () => _showPayoutSheet(context),
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
            RevenueMonthlyChart(summaries: _monthlySummary),
            ..._monthlySummary.map((s) => RevenueMonthCard(summary: s)),
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
                child: _filtered.isEmpty
                    ? const Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textHint),
                        SizedBox(height: 8),
                        Text('Không có dữ liệu', style: TextStyle(color: AppColors.textHint))
                      ]))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) => RevenueCommissionCard(record: _filtered[i]))),
          ]),
          // ── Tab 3: Payout history ──
          ListView(padding: const EdgeInsets.all(12), children: [
            if (_payouts.isEmpty)
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
              ..._payouts.map((p) => RevenuePayoutCard(payout: p)),
            ],
          ]),
        ]),
      ),
    );
  }

  void _showPayoutSheet(BuildContext context) {
    final amtCtrl = TextEditingController();
    BankAccountModel? selectedBank = _wallet.bankAccounts
        .firstWhere((b) => b.isDefault, orElse: () => _wallet.bankAccounts.first);
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
                          Text('Số dư khả dụng: ${_fmtVnd(_wallet.availableBalance)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                          const SizedBox(height: 16),
                          // Bank selector
                          const Text('Tài khoản nhận tiền',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ..._wallet.bankAccounts.map((b) => GestureDetector(
                                onTap: () => ss(() => selectedBank = b),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: selectedBank?.id == b.id
                                          ? const Color(0xFF0891B2).withOpacity(0.05)
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
                                            color: const Color(0xFF0891B2).withOpacity(0.1),
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
                                              color: AppColors.success.withOpacity(0.1),
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
                            _QuickAmt('500K', 500000, amtCtrl, ss),
                            const SizedBox(width: 6),
                            _QuickAmt('1M', 1000000, amtCtrl, ss),
                            const SizedBox(width: 6),
                            _QuickAmt('5M', 5000000, amtCtrl, ss),
                            const SizedBox(width: 6),
                            GestureDetector(
                                onTap: () => ss(() =>
                                    amtCtrl.text = _wallet.availableBalance.toInt().toString()),
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.info.withOpacity(0.1),
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
                                  final amt = double.tryParse(amtCtrl.text) ?? 0;
                                  if (amt <= 0 ||
                                      amt > _wallet.availableBalance ||
                                      selectedBank == null) return;
                                  Navigator.pop(ctx);
                                  HapticFeedback.mediumImpact();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('✅ Yêu cầu rút ${_fmtVnd(amt)} đã gửi'),
                                      backgroundColor: AppColors.success));
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

Widget _QuickAmt(String label, int amount, TextEditingController ctrl, StateSetter ss) =>
    GestureDetector(
        onTap: () => ss(() => ctrl.text = amount.toString()),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0xFF0891B2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(label,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))));
