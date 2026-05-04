import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_ticket_model.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/repositories/support_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'support_notifier.g.dart';

@riverpod
class SupportNotifier extends _$SupportNotifier
    with BaseNotifier<List<SupportTicketModel>> {
  late final SupportRepository _repository;

  @override
  Future<List<SupportTicketModel>> build() async {
    _repository = getIt<SupportRepository>();
    final result = await _repository.getMyTickets();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getMyTickets,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );

  Future<bool> createTicket(Map<String, dynamic> data) async {
    final result = await _repository.createTicket(data);
    return result.fold(
      onSuccess: (_) {
        refresh();
        return true;
      },
      onFailure: (_) => false,
    );
  }
}
