// import 'package:dat_san_247_mobile/features/category/domain/repositories/sport_category_repository.dart';
// import 'package:flutter/material.dart';

// import '../../../../core/errors/result.dart';
// import '../entities/sport_category_entity.dart';

// class GetSportCategory  {
//   GetSportCategory(this._repository);

//   final SportCategoryRepository _repository;

//   Future<Result<List<SportCategoryEntity>>> call() {
//     return _repository.getSportCategories();
//   }
// }



// 📁 lib/features/category/domain/usecases/get_sport_categories.dart
// ────────────────────────────────────────────────────────────────
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/usecases/usecase.dart';
import 'package:dat_san_247_mobile/features/customer/category/domain/entities/sport_category_entity.dart';
import 'package:dat_san_247_mobile/features/customer/category/domain/repositories/sport_category_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSportCategories implements UseCaseNoParams<List<SportCategoryEntity>> {
  final SportCategoryRepository _repository;

  GetSportCategories(this._repository);

  @override
  Future<Result<List<SportCategoryEntity>>> call() {
    return _repository.getSportCategories();
  }

  @override
  Future<Result<List<SportCategoryEntity>>> execute() {
    // TODO: implement execute
    throw UnimplementedError();
  }
}
