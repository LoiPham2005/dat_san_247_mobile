import 'package:dat_san_247_mobile/features/venue/presentation/controller/venue_controller.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/di/bindings/controller_binding/controller_binding.dart';
import 'package:dat_san_247_mobile/core/di/bindings/external_binding/external_binding.dart';
import 'package:dat_san_247_mobile/core/di/bindings/repository_binding/repository_binding.dart';

class InitialBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    // Wait for external dependencies
    await ExternalBinding().dependencies();

    // Then repositories that depend on DioClient
    RepositoryBinding().dependencies();

    // Finally controllers that depend on repositories
    ControllerBinding().dependencies();
  }
}
