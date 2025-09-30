import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Home/ProductDetail/product_detail_controlller.dart';
import 'package:utshop/Global/app_color.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({super.key});

  final controller = Get.put(ProductDetailController());

  // Danh sách ảnh từ assets
  final List<String> productImages = [
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        foregroundColor: AppColor.black,
        elevation: 0,
        title: const Text(
          "Chi tiết sản phẩm",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hiển thị ảnh sản phẩm
            Container(
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PageView.builder(
                  itemCount: productImages.length,
                  onPageChanged: (index) {
                    controller.updatePage(index);
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      productImages[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Lỗi tải ảnh'));
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  productImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    width: controller.currentPage.value == index ? 16.0 : 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color:
                          controller.currentPage.value == index
                              ? AppColor.primary
                              : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tên sản phẩm và nút yêu thích
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tên sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.isFavorite.value =
                            !controller.isFavorite.value;
                      },
                      child: AnimatedScale(
                        scale: controller.isFavorite.value ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            controller.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                controller.isFavorite.value
                                    ? Colors.red
                                    : AppColor.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Giá sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Text(
                    "Giá:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "200.000đ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Màu sắc
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Màu sắc",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8), // Giảm khoảng cách
                  Row(
                    children: [
                      _colorOption(
                        color: Colors.white,
                        borderColor: Colors.grey.shade300,
                        colorName: 'Trắng',
                      ),
                      const SizedBox(width: 16),
                      _colorOption(color: Colors.red, colorName: 'Đỏ'),
                      const SizedBox(width: 16),
                      _colorOption(color: Colors.black, colorName: 'Đen'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Kích thước
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kích thước",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _sizeOption(size: 'M'),
                      const SizedBox(width: 16),
                      _sizeOption(size: 'L'),
                      const SizedBox(width: 16),
                      _sizeOption(size: 'XL'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sizeOption({required String size}) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.setSize(size),
        child: AnimatedScale(
          scale: controller.selectedSize.value == size ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  controller.selectedSize.value == size
                      ? AppColor.primary.withOpacity(0.1)
                      : Colors.grey.shade100,
              border: Border.all(
                color:
                    controller.selectedSize.value == size
                        ? AppColor.primary
                        : Colors.grey.shade400,
                width: 1.5,
              ),
              boxShadow: [
                if (controller.selectedSize.value == size)
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  color:
                      controller.selectedSize.value == size
                          ? AppColor.primary
                          : AppColor.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorOption({
    required Color color,
    required String colorName,
    Color? borderColor,
  }) {
    return Obx(() {
      final isSelected = controller.selectedColor.value == colorName;
      return GestureDetector(
        onTap: () {
          controller.selectedColor.value = colorName;
        },
        child: AnimatedScale(
          scale: isSelected ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColor.primary
                            : (borderColor ?? Colors.grey.shade400),
                    width: isSelected ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.2),
                        blurRadius: 4, // Giảm bóng
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child:
                    isSelected
                        ? Icon(
                          Icons.check,
                          size: 14,
                          color:
                              color == Colors.white
                                  ? AppColor.primary
                                  : Colors.white,
                        )
                        : null,
              ),
              const SizedBox(height: 6),
              Text(
                colorName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColor.primary : AppColor.black,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
