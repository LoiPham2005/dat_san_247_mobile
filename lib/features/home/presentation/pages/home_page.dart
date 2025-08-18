import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/ext/widget_ext.dart';
import 'package:dat_san_247_mobile/core/widget/custom_image.dart';
import 'package:dat_san_247_mobile/features/home/presentation/controller/banner_controller.dart';
import 'package:dat_san_247_mobile/features/product/data/models/product_model.dart';
import 'package:dat_san_247_mobile/features/product/data/models/shoes_model.dart';
import 'package:dat_san_247_mobile/features/product/presentation/controller/product_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Lấy controller đã được đăng ký ở GetX
  final ProductController controller = Get.find<ProductController>();
  final BannerController bannerController = Get.find<BannerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SNEAK UP"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getTopSelling(),
        child: Column(
          children: [
            // hiển thị danh sách banner
            Obx(() {
              if (bannerController.bannerList.isEmpty) {
                return const Center(child: Text("Không có banner"));
              }
              return SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: bannerController.bannerList.length,
                  itemBuilder: (context, index) {
                    final banner = bannerController.bannerList[index];
                    return CustomImage(imageUrl: banner.media ?? "");
                  },
                ),
              );
            }).marginOnly(bottom: 10),

            Obx(() {
              // Hiển thị loading
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Gom tất cả shoes từ tất cả ProductModel
              final List shoesList = controller.topSellingShoes
                  .expand((productModel) => productModel.shoes ?? [])
                  .toList();

              if (shoesList.isEmpty) {
                return const Center(child: Text("Không có sản phẩm"));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: shoesList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final shoe = shoesList[index];
                  return ListTile(
                    leading: shoe.media != null && shoe.media!.isNotEmpty
                        ? CustomImage(
                            imageUrl: shoe.media!.first.url ?? "",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(width: 50, height: 50),
                    title: Text(shoe.name ?? "Không tên"),
                    subtitle: Text(shoe.description ?? ""),
                  );
                },
              );
            }).expand(),
          ],
        ),
      ),
    );
  }
}
