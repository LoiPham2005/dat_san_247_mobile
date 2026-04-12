import 'package:dat_san_247_mobile/core/base/errors/failures.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_ticket_model.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/repositories/support_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SupportCubit extends BaseCubit<List<SupportTicketModel>> {
  final SupportRepository _repository;

  SupportCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchMyTickets() async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.getMyTickets();

    result.fold(
      onSuccess: (tickets) => emit(BaseState.success(data: tickets)),
      onFailure: (f) => emit(BaseState.failure(error: f.userMessage)),
    );
  }

  Future<bool> createTicket(Map<String, dynamic> data) async {
    final result = await _repository.createTicket(data);
    return result.fold(
      onSuccess: (ticket) {
        fetchMyTickets();
        return true;
      },
      onFailure: (f) => false,
    );
  }
}
