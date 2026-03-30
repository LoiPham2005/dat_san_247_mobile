import 'package:injectable/injectable.dart';
import '../../../../../core/base/state/bloc/base_state.dart';
import '../../../../../core/base/state/cubit/base_cubit.dart';
import '../../data/models/promotion_model.dart';
import '../../data/repositories/deals_repository.dart';

@injectable
class DealsCubit extends BaseCubit<PromotionsResponse> {
  final DealsRepository _repository;

  DealsCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchDeals({int page = 1, int limit = 10}) async {
    await run(
      action: () => _repository.getDeals(
        page: page,
        limit: limit,
        status: 'ACTIVE',
        isPublic: true,
      ),
    );
  }
}
