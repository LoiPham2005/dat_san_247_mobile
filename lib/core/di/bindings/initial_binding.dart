import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/di/bindings/controller_binding/controller_binding.dart';
import 'package:dat_san_247_mobile/core/di/bindings/external_binding/external_binding.dart';
import 'package:dat_san_247_mobile/core/di/bindings/repository_binding/repository_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    ExternalBinding().dependencies();
    RepositoryBinding().dependencies();
    ControllerBinding().dependencies();
  }
}
