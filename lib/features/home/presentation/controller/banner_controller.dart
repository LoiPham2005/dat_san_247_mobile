import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dat_san_247_mobile/core/config/config_getx/base_controller.dart';
import 'package:dat_san_247_mobile/features/home/data/models/banner_model.dart';
import 'package:dat_san_247_mobile/features/home/data/repository/banner_repository.dart';

class BannerController extends BaseController {
  final BannerRepository bannerRepository = Get.find<BannerRepository>();
  RxList<BannerModel> bannerList = <BannerModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBanner();
  }

  Future<void> getBanner() {
    return fetchList(
        action: () => bannerRepository.getBanner(), targetList: bannerList);
  }
}
