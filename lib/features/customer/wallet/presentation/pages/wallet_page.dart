import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-15: Ví Điện Tử
// ──────────────────────────────────────────────────────────────────────────
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0; // 0=Tất cả, 1=Nạp, 2=TT, 3=Hoàn

  final WalletModel _wallet = WalletModel(
    id: 'wlt1',
    userId: 'u1',
    balance: 1250000,
    lockedBalance: 150000,
    isActive: true,
    updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
  );

  final List<TransactionModel> _transactions = [
    TransactionModel(
        id: 't1',
        type: TransactionType.DEPOSIT,
        amount: 500000,
        balanceAfter: 1250000,
        status: TransactionStatus.COMPLETED,
        description: 'Nạp tiền qua MoMo',
        createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    TransactionModel(
        id: 't2',
        type: TransactionType.PAYMENT,
        amount: 150000,
        balanceAfter: 750000,
        status: TransactionStatus.COMPLETED,
        description: 'Thanh toán đặt sân',
        bookingCode: 'DS24701234',
        createdAt: DateTime.now().subtract(const Duration(days: 1))),
    TransactionModel(
        id: 't3',
        type: TransactionType.REFUND,
        amount: 150000,
        balanceAfter: 900000,
        status: TransactionStatus.COMPLETED,
        description: 'Hoàn tiền hủy booking',
        bookingCode: 'DS24788002',
        createdAt: DateTime.now().subtract(const Duration(days: 3))),
    TransactionModel(
        id: 't4',
        type: TransactionType.PAYMENT,
        amount: 300000,
        balanceAfter: 750000,
        status: TransactionStatus.COMPLETED,
        description: 'Thanh toán đặt sân buổi tối',
        bookingCode: 'DS24799001',
        createdAt: DateTime.now().subtract(const Duration(days: 4))),
    TransactionModel(
        id: 't5',
        type: TransactionType.DEPOSIT,
        amount: 1000000,
        balanceAfter: 1050000,
        status: TransactionStatus.COMPLETED,
        description: 'Nạp tiền qua VNPay',
        createdAt: DateTime.now().subtract(const Duration(days: 7))),
    TransactionModel(
        id: 't6',
        type: TransactionType.PAYMENT,
        amount: 90000,
        balanceAfter: 50000,
        status: TransactionStatus.FAILED,
        description: 'Thanh toán thất bại',
        createdAt: DateTime.now().subtract(const Duration(days: 8))),
  ];

  List<TransactionModel> get _filtered {
    switch (_selectedFilter) {
      case 1:
        return _transactions
            .where((t) => t.type == TransactionType.DEPOSIT)
            .toList();
      case 2:
        return _transactions
            .where((t) => t.type == TransactionType.PAYMENT)
            .toList();
      case 3:
        return _transactions
            .where((t) => t.type == TransactionType.REFUND)
            .toList();
      default:
        return _transactions;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── Expandable header with balance ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryLightBrand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F7A35), Color(0xFF22C55E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ví DatSan247',
                            style: TextStyle(
                                color: AppColors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              fmt.format(_wallet.balance),
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Clipboard.setData(ClipboardData(
                                    text: _wallet.balance.toString()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: AppColors.white,
                                    size: 24),
                              ),
                            ),
                          ],
                        ),
                        if (_wallet.lockedBalance > 0) ...[
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.lock_outline_rounded,
                                color: AppColors.white70, size: 13),
                            const SizedBox(width: 4),
                            Text(
                                '${fmt.format(_wallet.lockedBalance)} đang giữ',
                                style: const TextStyle(
                                    color: AppColors.white70, fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(
                                'Khả dụng: ${fmt.format(_wallet.availableBalance)}',
                                style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ],
                        const SizedBox(height: 20),
                        // ── Quick actions ──
                        Row(
                          children: [
                            _QuickAction(
                                icon: Icons.add_rounded,
                                label: 'Nạp tiền',
                                onTap: () => _showTopUpSheet(context)),
                            const SizedBox(width: 12),
                            _QuickAction(
                                icon: Icons.history_rounded,
                                label: 'Giao dịch',
                                onTap: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Filter chips ──
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                        label: 'Tất cả',
                        selected: _selectedFilter == 0,
                        onTap: () => setState(() => _selectedFilter = 0)),
                    const SizedBox(width: 8),
                    _FilterChip(
                        label: '💰 Nạp tiền',
                        selected: _selectedFilter == 1,
                        onTap: () => setState(() => _selectedFilter = 1)),
                    const SizedBox(width: 8),
                    _FilterChip(
                        label: '🏟️ Thanh toán',
                        selected: _selectedFilter == 2,
                        onTap: () => setState(() => _selectedFilter = 2)),
                    const SizedBox(width: 8),
                    _FilterChip(
                        label: '↩️ Hoàn tiền',
                        selected: _selectedFilter == 3,
                        onTap: () => setState(() => _selectedFilter = 3)),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Transaction list ──
          _filtered.isEmpty
              ? SliverFillRemaining(child: _buildEmpty())
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final t = _filtered[i];
                      final showDateSeparator = i == 0 ||
                          !_isSameDay(_filtered[i - 1].createdAt, t.createdAt);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDateSeparator)
                            _DateSeparator(date: t.createdAt),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _TransactionTile(
                              transaction: t,
                              fmt: fmt,
                              onTap: () =>
                                  _showTransactionDetail(context, t, fmt),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: _filtered.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _showTopUpSheet(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final amounts = [50000, 100000, 200000, 500000, 1000000, 2000000];
    int? selected;
    final customCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Nạp tiền vào ví',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // Amount chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: amounts.map((a) {
                  final isSelected = selected == a;
                  return GestureDetector(
                    onTap: () => setModalState(() {
                      selected = a;
                      customCtrl.clear();
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLightBrand.withOpacity(0.1)
                            : AppColors.mutedLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isSelected
                                ? AppColors.primaryLightBrand
                                : AppColors.borderLight,
                            width: isSelected ? 1.5 : 1),
                      ),
                      child: Text(
                          NumberFormat.compactCurrency(
                                  locale: 'vi_VN', symbol: 'đ')
                              .format(a),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.primaryLightBrand
                                  : AppColors.textSecondary)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: customCtrl,
                keyboardType: TextInputType.number,
                onChanged: (v) => setModalState(() => selected = null),
                decoration: InputDecoration(
                  hintText: 'Nhập số khác...',
                  prefixIcon: const Icon(Icons.edit_rounded, size: 16),
                  filled: true,
                  fillColor: AppColors.mutedLight,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              // Payment method
              const Text('Qua cổng thanh toán',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _PaymentOption(
                      label: 'MoMo',
                      color: const Color(0xFFAD1457),
                      icon: Icons.phone_android_rounded),
                  const SizedBox(width: 10),
                  _PaymentOption(
                      label: 'VNPay',
                      color: const Color(0xFF0050AF),
                      icon: Icons.account_balance_rounded),
                  const SizedBox(width: 10),
                  _PaymentOption(
                      label: 'ZaloPay',
                      color: const Color(0xFF0068FF),
                      icon: Icons.payment_rounded),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('💳 Đang chuyển đến cổng thanh toán...'),
                        backgroundColor: AppColors.primaryLightBrand));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    selected != null
                        ? 'Nạp ${fmt.format(selected)}'
                        : 'Xác nhận nạp tiền',
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetail(
      BuildContext context, TransactionModel t, NumberFormat fmt) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: t.type.isCredit
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(_txIcon(t.type),
                  color: t.type.isCredit ? AppColors.success : AppColors.error,
                  size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              '${t.type.isCredit ? '+' : '-'}${fmt.format(t.amount)}',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: t.type.isCredit ? AppColors.success : AppColors.error),
            ),
            Text(t.type.label,
                style:
                    const TextStyle(color: AppColors.textHint, fontSize: 13)),
            const SizedBox(height: 20),
            _DetailRow(label: 'Nội dung', value: t.description ?? '—'),
            if (t.bookingCode != null)
              _DetailRow(label: 'Mã booking', value: t.bookingCode!),
            _DetailRow(label: 'Sau GD', value: fmt.format(t.balanceAfter)),
            _DetailRow(
                label: 'Thời gian',
                value: DateFormat('HH:mm dd/MM/yyyy').format(t.createdAt)),
            _DetailRow(label: 'Trạng thái', value: _txStatusLabel(t.status)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded,
                size: 60, color: AppColors.primaryLightBrand),
            SizedBox(height: 12),
            Text('Chưa có giao dịch nào',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  IconData _txIcon(TransactionType t) {
    switch (t) {
      case TransactionType.DEPOSIT:
        return Icons.add_circle_rounded;
      case TransactionType.PAYMENT:
        return Icons.sports_soccer_rounded;
      case TransactionType.REFUND:
        return Icons.undo_rounded;
      case TransactionType.PAYOUT:
        return Icons.arrow_upward_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  String _txStatusLabel(TransactionStatus s) {
    switch (s) {
      case TransactionStatus.COMPLETED:
        return '✅ Thành công';
      case TransactionStatus.PENDING:
        return '⏳ Đang xử lý';
      case TransactionStatus.FAILED:
        return '❌ Thất bại';
      case TransactionStatus.CANCELLED:
        return '🚫 Đã hủy';
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Sub widgets
// ──────────────────────────────────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.white, size: 18),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
        ),
      );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color:
                selected ? AppColors.primaryLightBrand : AppColors.mutedLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selected ? AppColors.white : AppColors.textSecondary)),
        ),
      );
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final NumberFormat fmt;
  final VoidCallback onTap;
  const _TransactionTile(
      {required this.transaction, required this.fmt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isCredit = t.type.isCredit;
    final isFailed = t.status == TransactionStatus.FAILED;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFailed
                    ? AppColors.mutedLight
                    : (isCredit
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.primaryLightBrand.withOpacity(0.08)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _icon(t.type),
                color: isFailed
                    ? AppColors.textHint
                    : (isCredit
                        ? AppColors.success
                        : AppColors.primaryLightBrand),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.type.label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  Text(
                    t.description ??
                        (t.bookingCode != null
                            ? 'Booking #${t.bookingCode}'
                            : ''),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}${fmt.format(t.amount)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isFailed
                        ? AppColors.textHint
                        : (isCredit
                            ? AppColors.success
                            : AppColors.textPrimary),
                    decoration: isFailed ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(DateFormat('HH:mm').format(t.createdAt),
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textHint)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon(TransactionType t) {
    switch (t) {
      case TransactionType.DEPOSIT:
        return Icons.add_circle_outline_rounded;
      case TransactionType.PAYMENT:
        return Icons.sports_soccer_rounded;
      case TransactionType.REFUND:
        return Icons.undo_rounded;
      case TransactionType.PAYOUT:
        return Icons.arrow_upward_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;
    final isYesterday = DateTime(now.year, now.month, now.day - 1) ==
        DateTime(date.year, date.month, date.day);
    final label = isToday
        ? 'Hôm nay'
        : isYesterday
            ? 'Hôm qua'
            : DateFormat('dd/MM/yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 13, color: AppColors.textHint)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      );
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _PaymentOption(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      );
}
