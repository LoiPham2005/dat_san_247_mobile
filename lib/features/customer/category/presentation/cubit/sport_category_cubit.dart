import 'package:dat_san_247_mobile/core/state_management/cubit/base_cubit.dart';

import '../../domain/usecases/get_sport_category.dart';

class SportCategoryCubit extends BaseCubit {
  SportCategoryCubit(this.getSportCategories);

  final GetSportCategories getSportCategories;

  Future<void> fetchSportCategories() async {
    await execute(
      action: () {
        return getSportCategories();
      },
    );
  }
}
