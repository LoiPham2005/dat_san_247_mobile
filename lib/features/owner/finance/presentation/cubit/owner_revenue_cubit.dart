import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/repositories/finance_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

part 'owner_revenue_cubit.freezed.dart';

@freezed
abstract class OwnerRevenueState with _$OwnerRevenueState {
  const factory OwnerRevenueState({
    WalletModel? wallet,
    FinanceStatsModel? overallStats,
    @Default([]) List<RevenueSummaryModel> monthlySummaries,
    @Default([]) List<CommissionRecordModel> commissions,
    @Default([]) List<PayoutRequestModel> payouts,
    @Default(false) bool isSubmittingPayout,
  }) = _OwnerRevenueState;
}

@injectable
class OwnerRevenueCubit extends BaseCubit<OwnerRevenueState> {
  final FinanceRepository _repository;
  OwnerRevenueCubit(this._repository) : super(const BaseState(status: BaseStatus.initial, data: OwnerRevenueState()));

  Future<void> initFinance(String? venueId) async {
    emit(BaseState.loading(previousData: state.data));
    
    // Fetch wallet, stats, commissions, and payouts in parallel
    final results = await Future.wait([
      _repository.getWallet(),
      _repository.getFinanceStats(venueId: venueId),
      _repository.getCommissions(venueId: venueId),
      _repository.getPayoutRequests(),
    ]);

    final walletRes = results[0] as dynamic;
    final statsRes = results[1] as dynamic;
    final commissionRes = results[2] as dynamic;
    final payoutRes = results[3] as dynamic;

    WalletModel? wallet;
    FinanceStatsModel? overallStats;
    List<CommissionRecordModel> commissions = [];
    List<PayoutRequestModel> payouts = [];

    walletRes.fold(onSuccess: (data) => wallet = data, onFailure: (err) => null);
    statsRes.fold(onSuccess: (data) => overallStats = data, onFailure: (err) => null);
    commissionRes.fold(onSuccess: (data) => commissions = data, onFailure: (err) => null);
    payoutRes.fold(onSuccess: (data) => payouts = data, onFailure: (err) => null);

    // Compute monthly summaries from commissions
    final summaries = _computeMonthlySummaries(commissions);

    emit(BaseState.success(
      data: state.data?.copyWith(
        wallet: wallet,
        overallStats: overallStats,
        monthlySummaries: summaries,
        commissions: commissions,
        payouts: payouts,
      ),
    ));
  }

  List<RevenueSummaryModel> _computeMonthlySummaries(List<CommissionRecordModel> records) {
    if (records.isEmpty) return [];
    
    final Map<String, List<CommissionRecordModel>> grouped = {};
    for (var r in records) {
      final month = DateFormat('yyyy-MM').format(r.bookingDate);
      grouped.putIfAbsent(month, () => []).add(r);
    }
    
    final sortedMonths = grouped.keys.toList()..sort((a, b) => b.compareTo(a)); // Newest first
    
    return sortedMonths.map((month) {
      final monthRecords = grouped[month]!;
      double totalBooking = 0;
      double totalComm = 0;
      double totalOwner = 0;
      double paid = 0;
      double pending = 0;
      
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
    
    emit(BaseState.success(data: state.data?.copyWith(isSubmittingPayout: true)));
    
    final res = await _repository.createPayoutRequest(amount, bankAccountId);
    res.fold(
      onFailure: (err) => emit(BaseState.failure(error: err.message, previousData: state.data?.copyWith(isSubmittingPayout: false))),
      onSuccess: (newPayout) {
        final currentPayouts = <PayoutRequestModel>[newPayout, ...(state.data?.payouts ?? [])];
        emit(BaseState.success(
          message: 'Đã gửi yêu cầu rút tiền thành công',
          data: state.data?.copyWith(
            payouts: currentPayouts,
            isSubmittingPayout: false,
          ),
        ));
        getWallet();
      },
    );
  }

  Future<void> getWallet() async {
    final res = await _repository.getWallet();
    res.fold(
      onFailure: (err) => null,
      onSuccess: (data) => emit(BaseState.success(data: state.data?.copyWith(wallet: data))),
    );
  }
}
