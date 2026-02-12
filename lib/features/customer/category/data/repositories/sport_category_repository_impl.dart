import 'package:injectable/injectable.dart';

import '../../../../../core/errors/result.dart';
import '../../domain/entities/sport_category_entity.dart';
import '../../domain/repositories/sport_category_repository.dart';
import '../datasourse/sport_category_remote_datasourse.dart';
import '../model/sport_category_model.dart';

@LazySingleton(as: SportCategoryRepository)
class SportCategoryRepositoryImpl implements SportCategoryRepository {
  final SportCategoryRemoteDataSource _remoteDataSource;

  SportCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<SportCategoryEntity>>> getSportCategories() async {
    final result = await _remoteDataSource.getSportCategories();

    // ✅ Cách 1: Cast rõ ràng kiểu
    return (result as Result<List<SportCategoryModel>>).mapItems((model) => model.toEntity());

    // ✅ Cách 2 (Alternative): Dùng map thay vì mapItems
    // return result.map(
    //   (models) => models.map((model) => model.toEntity()).toList(),
    // );
  }
}
