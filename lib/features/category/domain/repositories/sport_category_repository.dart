import 'package:dat_san_247_mobile/core/errors/result.dart';

import '../entities/sport_category_entity.dart';

abstract class SportCategoryRepository {
  Future<Result<List<SportCategoryEntity>>> getSportCategories();
}
