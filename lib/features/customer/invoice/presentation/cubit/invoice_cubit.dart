import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/repositories/invoice_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class InvoiceCubit extends BaseCubit<List<InvoiceModel>> {
  final InvoiceRepository _repository;

  InvoiceCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchInvoices() async {
    await run(
      action: () => _repository.getMyInvoices(),
    );
  }
}
