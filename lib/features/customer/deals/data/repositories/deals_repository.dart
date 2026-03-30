import 'package:injectable/injectable.dart';
import '../../../../../core/base/errors/failures.dart';
import '../../../../../core/base/errors/result.dart';
import '../models/promotion_model.dart';
import '../services/deals_service.dart';

@LazySingleton()
class DealsRepository {
  final DealsService _service;

  DealsRepository(this._service);

  Future<Result<PromotionsResponse>> getDeals({
    int? page,
    int? limit,
    String? status,
    bool? isPublic,
  }) async {
    try {
      final response = await _service.getDeals(
        page: page,
        limit: limit,
        status: status,
        isPublic: isPublic,
      );

      if (response.isSuccess && response.data != null) {
        final metaJson = response.meta as Map<String, dynamic>?;
        final promotions = response.data!;
        
        return ResultSuccess(PromotionsResponse(
          data: promotions,
          meta: metaJson != null 
              ? PromotionsMeta.fromJson(metaJson)
              : const PromotionsMeta(total: 0, page: 1, limit: 10, totalPages: 1),
        ));
      }
      return ResultFailure(ServerFailure(message: response.message ?? 'Không thể tải danh sách khuyến mãi'));
    } catch (e) {
      return ResultFailure(ServerFailure(message: e.toString()));
    }
  }
}
