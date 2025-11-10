import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Wishlist/wishlish_controller.dart';
import 'package:utshop/Global/app_color.dart';

class Wishlish extends StatelessWidget {
  Wishlish({super.key});

  final controller = Get.put(WishlishController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: RefreshIndicator(
        color: AppColor.primary,
        backgroundColor: Colors.white,
        onRefresh: () => controller.getWishlist(),
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.wishlistProduct.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (controller.wishlistProduct.isEmpty) {
            return LayoutBuilder(
              builder:
                  (context, constraints) => SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Text(
                          "Bạn chưa có sản phẩm yêu thích nào.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20),
            itemCount: controller.wishlistProduct.length,
            itemBuilder: (context, index) {
              final product = controller.wishlistProduct[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: const Offset(0, -2),
                                blurRadius: 6,
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(
                                product.imageUrl ??
                                    "https://via.placeholder.com/150",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? "Tên sản phẩm",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${(double.tryParse(product.price ?? '0') ?? 0).toStringAsFixed(0)} ₫",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              if (product.uuid != null) {
                                controller.removeWishlist(product.uuid!);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
