import 'package:dat_san_247_mobile/core/constants/api_constants.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/network/api_client.dart';
import 'package:injectable/injectable.dart';

import '../model/sport_category_model.dart';

abstract class SportCategoryRemoteDataSource {
  Future<Result<SportCategoryModel>> getSportCategories();
}

@LazySingleton(as: SportCategoryRemoteDataSource)
class SportCategoryRemoteDataSourceImpl
    implements SportCategoryRemoteDataSource {
  SportCategoryRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<SportCategoryModel>> getSportCategories() async {
    return _apiClient.get(
      ApiConstants.categories,
      (json) => SportCategoryModel.fromJson(json),
    );
  }
}
