import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/services/finance_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FinanceRepository with ApiHandlerMixin {
  final FinanceService _service;
  FinanceRepository(this._service);

  Future<Result<WalletModel>> getWallet() {
    return safeCallUnwrap(() => _service.getWallet());
  }

  Future<Result<List<BankAccountModel>>> getBankAccounts() {
    return safeCallUnwrap(() => _service.getBankAccounts());
  }

  Future<Result<BankAccountModel>> addBankAccount(Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.addBankAccount(data));
  }

  Future<Result<void>> deleteBankAccount(String id) {
    return safeCallUnwrap(() => _service.deleteBankAccount(id)).thenMap((_) => null);
  }

  Future<Result<List<PayoutRequestModel>>> getPayoutRequests() {
    return safeCallUnwrap(() => _service.getPayoutRequests());
  }

  Future<Result<PayoutRequestModel>> createPayoutRequest(double amount, String bankAccountId) {
    return safeCallUnwrap(() => _service.createPayoutRequest({
      'amount': amount,
      'bank_account_id': bankAccountId,
    }));
  }

  Future<Result<FinanceStatsModel>> getFinanceStats({String? venueId}) {
    return safeCallUnwrap(() => _service.getFinanceStats(venueId));
  }

  Future<Result<List<CommissionRecordModel>>> getCommissions({String? venueId}) {
    return safeCallUnwrap(() => _service.getCommissions(venueId));
  }
}
