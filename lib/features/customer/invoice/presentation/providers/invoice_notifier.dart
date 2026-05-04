import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/repositories/invoice_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invoice_notifier.g.dart';

@riverpod
class InvoiceNotifier extends _$InvoiceNotifier
    with BaseNotifier<List<InvoiceModel>> {
  late final InvoiceRepository _repository;

  @override
  Future<List<InvoiceModel>> build() async {
    _repository = getIt<InvoiceRepository>();
    final result = await _repository.getMyInvoices();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getMyInvoices,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );
}
