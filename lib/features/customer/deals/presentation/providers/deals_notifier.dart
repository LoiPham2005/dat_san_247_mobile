import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/deals/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/customer/deals/data/repositories/deals_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deals_notifier.g.dart';

@riverpod
class DealsNotifier extends _$DealsNotifier
    with BaseNotifier<PromotionsResponse> {
  late final DealsRepository _repository;

  @override
  Future<PromotionsResponse> build() async {
    _repository = getIt<DealsRepository>();
    final result = await _repository.getDeals(
      page: 1,
      limit: 10,
      status: 'ACTIVE',
      isPublic: true,
    );
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh({int page = 1, int limit = 10}) => runResult(
        action: () => _repository.getDeals(
          page: page,
          limit: limit,
          status: 'ACTIVE',
          isPublic: true,
        ),
        mapper: (data) => data,
        keepPreviousOnLoading: true,
      );
}
