import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/repositories/finance_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_revenue_notifier.freezed.dart';
part 'owner_revenue_notifier.g.dart';

@freezed
abstract class OwnerRevenueData with _$OwnerRevenueData {
  const factory OwnerRevenueData({
    WalletModel? wallet,
    FinanceStatsModel? overallStats,
    @Default([]) List<RevenueSummaryModel> monthlySummaries,
    @Default([]) List<CommissionRecordModel> commissions,
    @Default([]) List<PayoutRequestModel> payouts,
    @Default(false) bool isSubmittingPayout,
  }) = _OwnerRevenueData;
}

@riverpod
class OwnerRevenueNotifier extends _$OwnerRevenueNotifier
    with BaseNotifier<OwnerRevenueData> {
  late final FinanceRepository _repository;
  String? _venueId;

  @override
  Future<OwnerRevenueData> build(String? venueId) async {
    _repository = getIt<FinanceRepository>();
    _venueId = venueId;
    return _loadAll(venueId);
  }

  Future<OwnerRevenueData> _loadAll(String? venueId) async {
    final results = await Future.wait([
      _repository.getWallet(),
      _repository.getFinanceStats(venueId: venueId),
      _repository.getCommissions(venueId: venueId),
      _repository.getPayoutRequests(),
    ]);

    WalletModel? wallet;
    FinanceStatsModel? overallStats;
    var commissions = <CommissionRecordModel>[];
    var payouts = <PayoutRequestModel>[];

    (results[0] as dynamic).fold(
      onSuccess: (data) => wallet = data,
      onFailure: (_) => null,
    );
    (results[1] as dynamic).fold(
      onSuccess: (data) => overallStats = data,
      onFailure: (_) => null,
    );
    (results[2] as dynamic).fold(
      onSuccess: (data) => commissions = data,
      onFailure: (_) => null,
    );
    (results[3] as dynamic).fold(
      onSuccess: (data) => payouts = data,
      onFailure: (_) => null,
    );

    return OwnerRevenueData(
      wallet: wallet,
      overallStats: overallStats,
      monthlySummaries: _computeMonthlySummaries(commissions),
      commissions: commissions,
      payouts: payouts,
    );
  }

  Future<void> refresh() => runAsync(
        action: () => _loadAll(_venueId),
        keepPreviousOnLoading: true,
      );

  List<RevenueSummaryModel> _computeMonthlySummaries(
      List<CommissionRecordModel> records) {
    if (records.isEmpty) return [];
    final grouped = <String, List<CommissionRecordModel>>{};
    for (var r in records) {
      final month = DateFormat('yyyy-MM').format(r.bookingDate);
      grouped.putIfAbsent(month, () => []).add(r);
    }
    final sortedMonths = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedMonths.map((month) {
      final monthRecords = grouped[month]!;
      double totalBooking = 0, totalComm = 0, totalOwner = 0, paid = 0, pending = 0;
      for (var r in monthRecords) {
        totalBooking += r.bookingAmount;
        totalComm += r.commissionAmount;
        totalOwner += r.ownerReceives;
        if (r.status == CommissionStatus.PAID) {
          paid += r.ownerReceives;
        } else {
          pending += r.ownerReceives;
        }
      }
      return RevenueSummaryModel(
        month: month,
        bookingCount: monthRecords.length,
        totalBookingAmount: totalBooking,
        totalCommissionAmount: totalComm,
        totalOwnerReceives: totalOwner,
        paidAmount: paid,
        pendingAmount: pending,
      );
    }).toList();
  }

  Future<void> createPayoutRequest(double amount, String bankAccountId) async {
    if (amount <= 0) return;
    final current = currentData;
    if (current == null) return;
    state = AsyncData(current.copyWith(isSubmittingPayout: true));

    final res = await _repository.createPayoutRequest(amount, bankAccountId);
    res.fold(
      onFailure: (err) {
        state = AsyncData(current.copyWith(isSubmittingPayout: false));
      },
      onSuccess: (newPayout) {
        state = AsyncData(current.copyWith(
          payouts: [newPayout, ...current.payouts],
          isSubmittingPayout: false,
        ));
        _refreshWallet();
      },
    );
  }

  Future<void> _refreshWallet() async {
    final res = await _repository.getWallet();
    res.fold(
      onFailure: (_) => null,
      onSuccess: (data) {
        final current = currentData;
        if (current == null) return;
        state = AsyncData(current.copyWith(wallet: data));
      },
    );
  }
}
