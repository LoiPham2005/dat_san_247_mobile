import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/data/models/owner_finance_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-11: Doanh Thu & Hoa Hồng
// DB: commission_records, wallets, payout_requests, payout_bank_accounts
// ══════════════════════════════════════════════════════════════════════════════
class OwnerRevenuePage extends StatefulWidget {
  const OwnerRevenuePage({super.key});
  @override
  State<OwnerRevenuePage> createState() => _OwnerRevenuePageState();
}

class _OwnerRevenuePageState extends State<OwnerRevenuePage>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  late TabController _tabCtrl;
  CommissionStatus? _statusFilter;

  final _wallet = WalletModel(
    id: 'w1', userId: 'u1',
    balance: 12850000.0, lockedBalance: 1200000.0,
    isActive: true, updatedAt: DateTime.now(),
    bankAccounts: [
      const BankAccountModel(id:'ba1', walletId:'w1', bankName:'Vietcombank', bankCode:'VCB', accountNumber:'0011004123456', accountName:'NGUYEN VAN AN', isDefault:true),
      const BankAccountModel(id:'ba2', walletId:'w1', bankName:'Techcombank', bankCode:'TCB', accountNumber:'19038876543210', accountName:'NGUYEN VAN AN', isDefault:false),
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
    return List.generate(4, (i) => RevenueSummaryModel(
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
      CommissionRecordModel(id:'c1', bookingId:'b1', bookingCode:'DS24800101', venueId:'v1', venueName:'Sân Bóng ABC', ownerId:'u1', bookingDate:now.subtract(const Duration(days:1)), courtName:'Sân A (5)', customerName:'Nguyễn Văn An', bookingAmount:300000, commissionRate:10, commissionAmount:30000, ownerReceives:270000, status:CommissionStatus.PAID, paidAt:now.subtract(const Duration(hours:6)), createdAt:now.subtract(const Duration(days:1))),
      CommissionRecordModel(id:'c2', bookingId:'b2', bookingCode:'DS24800102', venueId:'v1', venueName:'Sân Bóng ABC', ownerId:'u1', bookingDate:now.subtract(const Duration(hours:8)), courtName:'Sân B (7)', customerName:'Lê Thị Bình', bookingAmount:400000, commissionRate:10, commissionAmount:40000, ownerReceives:360000, status:CommissionStatus.APPROVED, createdAt:now.subtract(const Duration(hours:8))),
      CommissionRecordModel(id:'c3', bookingId:'b3', bookingCode:'DS24800103', venueId:'v1', venueName:'Sân Bóng ABC', ownerId:'u1', bookingDate:now.subtract(const Duration(days:2)), courtName:'Sân Tennis', customerName:'Phạm Quốc Cường', bookingAmount:500000, commissionRate:10, commissionAmount:50000, ownerReceives:450000, status:CommissionStatus.PAID, paidAt:now.subtract(const Duration(days:1)), createdAt:now.subtract(const Duration(days:2))),
      CommissionRecordModel(id:'c4', bookingId:'b4', bookingCode:'DS24800104', venueId:'v2', venueName:'Sân Cầu Lông XYZ', ownerId:'u1', bookingDate:now, courtName:'Cầu Lông', customerName:'Hoàng Minh Đức', bookingAmount:200000, commissionRate:10, commissionAmount:20000, ownerReceives:180000, status:CommissionStatus.PENDING, createdAt:now),
      CommissionRecordModel(id:'c5', bookingId:'b5', bookingCode:'DS24800105', venueId:'v1', venueName:'Sân Bóng ABC', ownerId:'u1', bookingDate:now.subtract(const Duration(days:3)), courtName:'Sân A (5)', customerName:'Trần Văn Em', bookingAmount:300000, commissionRate:10, commissionAmount:30000, ownerReceives:270000, status:CommissionStatus.PAID, paidAt:now.subtract(const Duration(days:2)), createdAt:now.subtract(const Duration(days:3))),
    ];
  }

  static List<PayoutRequestModel> _buildPayouts() {
    final now = DateTime.now();
    return [
      PayoutRequestModel(id:'pr1', userId:'u1', amount:5000000.0, status:PayoutStatus.COMPLETED, bankAccountId:'ba1', bankAccountName:'NGUYEN VAN AN', bankName:'Vietcombank', processedAt:now.subtract(const Duration(days:5)), createdAt:now.subtract(const Duration(days:7))),
      PayoutRequestModel(id:'pr2', userId:'u1', amount:3000000.0, status:PayoutStatus.PROCESSING, bankAccountId:'ba1', bankAccountName:'NGUYEN VAN AN', bankName:'Vietcombank', createdAt:now.subtract(const Duration(days:1))),
    ];
  }


  List<CommissionRecordModel> get _filtered =>
    _statusFilter == null ? _records : _records.where((r) => r.status == _statusFilter).toList();

  double get _totalPending => _records.where((r) => r.status == CommissionStatus.PENDING || r.status == CommissionStatus.APPROVED).fold(0.0, (sum, r) => sum + r.ownerReceives);
  double get _totalPaid => _records.where((r) => r.status == CommissionStatus.PAID).fold(0.0, (sum, r) => sum + r.ownerReceives);

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true, expandedHeight: 200, backgroundColor: _brand,
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
            actions: [IconButton(icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white), onPressed: () => _showPayoutSheet(context))],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, Color(0xFF0BC5EA)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 46, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Doanh Thu & Hoa Hồng', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  // Wallet card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.3))),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Số dư ví', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        Text(_fmtVnd(_wallet.availableBalance), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                        Text('Khoá: ${_fmtVnd(_wallet.lockedBalance)}', style: const TextStyle(color: Colors.white60, fontSize: 10)),
                      ])),
                      ElevatedButton.icon(
                        onPressed: () => _showPayoutSheet(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        icon: const Icon(Icons.upload_rounded, size: 14, color: Color(0xFF0891B2)),
                        label: const Text('Rút tiền', style: TextStyle(color: Color(0xFF0891B2), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    _WChip('Chờ nhận', _fmtVnd(_totalPending), AppColors.warning),
                    const SizedBox(width: 8),
                    _WChip('Đã nhận', _fmtVnd(_totalPaid), AppColors.success),
                  ]),
                ]))),
              ),
              title: const Text('Doanh Thu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            bottom: TabBar(
              controller: _tabCtrl,
              indicatorColor: Colors.white, indicatorWeight: 3,
              labelColor: Colors.white, unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              tabs: const [Tab(text: 'Theo Tháng'), Tab(text: 'Chi Tiết'), Tab(text: 'Rút Tiền')],
            ),
          ),
        ],
        body: TabBarView(controller: _tabCtrl, children: [
          // ── Tab 1: Monthly summary ──
          _MonthlyTab(summaries: _monthlySummary),
          // ── Tab 2: Commission records ──
          _RecordsTab(
            records: _filtered,
            statusFilter: _statusFilter,
            onFilterChanged: (s) => setState(() => _statusFilter = s),
          ),
          // ── Tab 3: Payout history ──
          _PayoutTab(payouts: _payouts, wallet: _wallet, onRequestPayout: () => _showPayoutSheet(context)),
        ]),
      ),
    );
  }

  void _showPayoutSheet(BuildContext context) {
    final amtCtrl = TextEditingController();
    BankAccountModel? selectedBank = _wallet.bankAccounts.firstWhere((b) => b.isDefault, orElse: () => _wallet.bankAccounts.first);
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          const Row(children: [Icon(Icons.upload_rounded, color: Color(0xFF0891B2)), SizedBox(width: 8), Text('Yêu Cầu Rút Tiền', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 4),
          Text('Số dư khả dụng: ${_fmtVnd(_wallet.availableBalance)}', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
          const SizedBox(height: 16),
          // Bank selector
          const Text('Tài khoản nhận tiền', style: TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._wallet.bankAccounts.map((b) => GestureDetector(
            onTap: () => ss(() => selectedBank = b),
            child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: selectedBank?.id == b.id ? const Color(0xFF0891B2).withOpacity(0.05) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: selectedBank?.id == b.id ? const Color(0xFF0891B2) : AppColors.borderLight)),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFF0891B2).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Center(child: Icon(Icons.account_balance_rounded, size: 18, color: Color(0xFF0891B2)))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b.bankName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('${b.maskedAccount} · ${b.accountName}', style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                ])),
                if (b.isDefault) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Text('Mặc định', style: TextStyle(fontSize: 9, color: AppColors.success, fontWeight: FontWeight.bold))),
                if (selectedBank?.id == b.id) const Icon(Icons.check_circle_rounded, color: Color(0xFF0891B2), size: 18),
              ]),
            ),
          )),
          const SizedBox(height: 10),
          TextField(controller: amtCtrl, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Số tiền rút (đ) *', prefixIcon: const Icon(Icons.monetization_on_outlined), suffixText: 'đ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(height: 8),
          Row(children: [
            _QuickAmt('500K', 500000, amtCtrl, ss),
            const SizedBox(width: 6),
            _QuickAmt('1M', 1000000, amtCtrl, ss),
            const SizedBox(width: 6),
            _QuickAmt('5M', 5000000, amtCtrl, ss),
            const SizedBox(width: 6),
            GestureDetector(onTap: () => ss(() => amtCtrl.text = _wallet.availableBalance.toInt().toString()), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('Tất cả', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.info)))),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(amtCtrl.text) ?? 0;
              if (amt <= 0 || amt > _wallet.availableBalance || selectedBank == null) return;
              Navigator.pop(ctx);
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Yêu cầu rút ${_fmtVnd(amt)} đã gửi'), backgroundColor: AppColors.success));
              _tabCtrl.animateTo(2);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Gửi Yêu Cầu Rút Tiền', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ])),
      )),
    );
  }
}

// ── Tab 1: Monthly ────────────────────────────────────────────────────────────
class _MonthlyTab extends StatelessWidget {
  final List<RevenueSummaryModel> summaries;
  const _MonthlyTab({required this.summaries});

  @override
  Widget build(BuildContext context) {
    final maxAmount = summaries.map((s) => s.totalOwnerReceives).reduce((a, b) => a > b ? a : b);
    return ListView(padding: const EdgeInsets.all(12), children: [
      // Bar chart
      Container(
        padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Doanh Thu Thực Nhận (4 tháng gần nhất)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(height: 120, child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: summaries.reversed.toList().map((s) {
              final ratio = maxAmount > 0 ? s.totalOwnerReceives / maxAmount : 0.0;
              final label = s.month.substring(5); // 'MM'
              return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(_fmtK(s.totalOwnerReceives), style: const TextStyle(fontSize: 8, color: AppColors.textHint)),
                const SizedBox(height: 2),
                AnimatedContainer(duration: const Duration(milliseconds: 500), height: 100 * ratio, decoration: BoxDecoration(color: const Color(0xFF0891B2).withOpacity(0.85), borderRadius: BorderRadius.circular(6))),
                const SizedBox(height: 4),
                Text('Th$label', style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
              ])));
            }).toList(),
          )),
        ]),
      ),
      // Monthly cards
      ...summaries.map((s) => _MonthCard(summary: s)),
    ]);
  }
}

class _MonthCard extends StatefulWidget {
  final RevenueSummaryModel summary;
  const _MonthCard({required this.summary});
  @override
  State<_MonthCard> createState() => _MonthCardState();
}
class _MonthCardState extends State<_MonthCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final s = widget.summary;
    final dt = DateTime.parse('${s.month}-01');
    final label = DateFormat('MMMM yyyy', 'vi').format(dt);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Column(children: [
        GestureDetector(onTap: () => setState(() => _expanded = !_expanded), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
            Text('${s.bookingCount} booking', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(_fmtVnd(s.totalOwnerReceives), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0891B2))),
            if (s.pendingAmount > 0) Text('Chờ: ${_fmtVnd(s.pendingAmount)}', style: const TextStyle(fontSize: 10, color: AppColors.warning)),
          ]),
          const SizedBox(width: 8),
          Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: AppColors.textHint),
        ]))),
        if (_expanded) ...[
          const Divider(height: 1, color: AppColors.borderLight),
          Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 12), child: Column(children: [
            _RevRow('Tổng booking', _fmtVnd(s.totalBookingAmount)),
            _RevRow('Hoa hồng platform (${(s.totalCommissionAmount / s.totalBookingAmount * 100).toStringAsFixed(1)}%)', '- ${_fmtVnd(s.totalCommissionAmount)}', color: AppColors.error),
            const Divider(height: 12, color: AppColors.borderLight),
            _RevRow('Thực nhận', _fmtVnd(s.totalOwnerReceives), bold: true, color: const Color(0xFF0891B2)),
            _RevRow('Đã thanh toán', _fmtVnd(s.paidAmount), color: AppColors.success),
            if (s.pendingAmount > 0) _RevRow('Còn chờ', _fmtVnd(s.pendingAmount), color: AppColors.warning),
          ])),
        ],
      ]),
    );
  }
}

// ── Tab 2: Records ────────────────────────────────────────────────────────────
class _RecordsTab extends StatelessWidget {
  final List<CommissionRecordModel> records;
  final CommissionStatus? statusFilter;
  final void Function(CommissionStatus?) onFilterChanged;
  const _RecordsTab({required this.records, required this.statusFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          _FChip('Tất cả', statusFilter == null, () => onFilterChanged(null)),
          ...CommissionStatus.values.map((s) => _FChip(s.label, statusFilter == s, () => onFilterChanged(statusFilter == s ? null : s))),
        ])),
      ),
      Expanded(child: records.isEmpty
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textHint), SizedBox(height: 8), Text('Không có dữ liệu', style: TextStyle(color: AppColors.textHint))]))
        : ListView.builder(padding: const EdgeInsets.all(12), itemCount: records.length, itemBuilder: (_, i) => _CommCard(record: records[i]))),
    ]);
  }
}

class _CommCard extends StatelessWidget {
  final CommissionRecordModel record;
  const _CommCard({required this.record});
  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final statusColor = switch (record.status) {
      CommissionStatus.PENDING   => AppColors.warning,
      CommissionStatus.APPROVED  => AppColors.info,
      CommissionStatus.PAID      => AppColors.success,
      CommissionStatus.CANCELLED => AppColors.error,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(record.status.emoji, style: const TextStyle(fontSize: 16)),
          ])),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(record.bookingCode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          Text('${record.customerName} · ${record.courtName}', style: const TextStyle(fontSize: 10, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(DateFormat('dd/MM/yyyy').format(record.bookingDate), style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(_fmtVnd(record.ownerReceives), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: brand)),
          Text('-${record.commissionRate.toStringAsFixed(0)}% = -${_fmtVnd(record.commissionAmount)}', style: const TextStyle(fontSize: 9, color: AppColors.error)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(record.status.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor))),
        ]),
      ]),
    );
  }
}

// ── Tab 3: Payout ─────────────────────────────────────────────────────────────
class _PayoutTab extends StatelessWidget {
  final List<PayoutRequestModel> payouts;
  final WalletModel wallet;
  final VoidCallback onRequestPayout;
  const _PayoutTab({required this.payouts, required this.wallet, required this.onRequestPayout});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(12), children: [
      if (payouts.isEmpty)
        const Center(child: Padding(padding: EdgeInsets.all(40), child: Column(children: [Icon(Icons.account_balance_outlined, size: 48, color: AppColors.textHint), SizedBox(height: 8), Text('Chưa có yêu cầu rút tiền', style: TextStyle(color: AppColors.textHint))])))
      else ...[
        const Text('Lịch Sử Rút Tiền', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textHint)),
        const SizedBox(height: 8),
        ...payouts.map((p) {
          final statusColor = switch (p.status) {
            PayoutStatus.PENDING    => AppColors.warning,
            PayoutStatus.PROCESSING => AppColors.info,
            PayoutStatus.COMPLETED  => AppColors.success,
            PayoutStatus.REJECTED   => AppColors.error,
            PayoutStatus.CANCELLED  => AppColors.textHint,
          };
          return Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.account_balance_rounded, color: statusColor, size: 20)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${p.bankName} · ${p.bankAccountName}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(p.createdAt), style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                if (p.rejectionReason != null) Text('Từ chối: ${p.rejectionReason}', style: const TextStyle(fontSize: 10, color: AppColors.error)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(_fmtVnd(p.amount), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(p.status.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor))),
              ]),
            ]),
          );
        }),
      ],
    ]);
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────
String _fmtVnd(double v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M đ';
  if (v >= 1000) return '${(v / 1000).round()}K đ';
  return '${v.toStringAsFixed(0)} đ';
}
String _fmtK(double v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(0)}M';
  if (v >= 1000) return '${(v / 1000).round()}K';
  return v.toStringAsFixed(0);
}


class _WChip extends StatelessWidget {
  final String label, value; final Color color;
  const _WChip(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.3))),
    child: Column(children: [Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))]),
  );
}

class _RevRow extends StatelessWidget {
  final String label, value; final bool bold; final Color? color;
  const _RevRow(this.label, this.value, {this.bold = false, this.color});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
    Expanded(child: Text(label, style: TextStyle(fontSize: 11, color: color ?? AppColors.textSecondary, fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
    Text(value, style: TextStyle(fontSize: 11, color: color ?? AppColors.textPrimary, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
  ]));
}

class _FChip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _FChip(this.label, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () { HapticFeedback.selectionClick(); onTap(); }, child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: selected ? const Color(0xFF0891B2) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: selected ? const Color(0xFF0891B2) : AppColors.borderLight)), child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textSecondary))));
}

Widget _QuickAmt(String label, int amount, TextEditingController ctrl, StateSetter ss) =>
  GestureDetector(onTap: () => ss(() => ctrl.text = amount.toString()), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: const Color(0xFF0891B2).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))));
