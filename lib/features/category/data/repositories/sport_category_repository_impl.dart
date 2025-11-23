import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/features/category/data/datasourse/sport_category_remote_datasourse.dart';
import 'package:dat_san_247_mobile/features/category/data/model/sport_category_model.dart';
import 'package:dat_san_247_mobile/features/category/domain/entities/sport_category_entity.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/sport_category_repository.dart';

@LazySingleton(as: SportCategoryRepository)
class SportCategoryRepositoryImpl implements SportCategoryRepository {
  SportCategoryRepositoryImpl(this._remoteDataSource);

  final SportCategoryRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<SportCategoryEntity>>> getSportCategories() async {
    final result = await _remoteDataSource.getSportCategories();
    return result.mapList((data) => data.toEntity());
  }
}
