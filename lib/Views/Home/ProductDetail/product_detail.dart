import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Home/ProductDetail/product_detail_controlller.dart';
import 'package:utshop/Global/app_color.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({super.key});

  final controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        foregroundColor: AppColor.white,
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: const Text(
          "Chi tiết sản phẩm",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        final product = controller.product.value;
        final images = product.images ?? [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần Slide ảnh
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      controller.updatePage(index);
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index].url ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primary,
                              strokeWidth: 2,
                            ),
                          );
                        },
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
                () => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => GestureDetector(
                          onTap: () => controller.updatePage(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width:
                                controller.currentPage.value == index
                                    ? 24.0
                                    : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                                  controller.currentPage.value == index
                                      ? AppColor.primary
                                      : Colors.grey.withAlpha(100),
                              boxShadow: [
                                if (controller.currentPage.value == index)
                                  BoxShadow(
                                    color: AppColor.primary.withAlpha(20),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${controller.currentPage.value + 1}/${images.length}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Phần Tên và Nút yêu thích
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name ?? 'Đang tải tên...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Nút Yêu thích
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
                                  color: Colors.black.withAlpha(80),
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
              // Phần Giá
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Text(
                      "Giá:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.formatPrice(product.price ?? 0),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Tồn kho: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Obx(
                          () => Text(
                            controller.currentStock.value.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text(
                          "4.5",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Màu sắc",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:
                                  controller.availableColors.map((colorInt) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: _colorOption(
                                        colorValue: colorInt,
                                        color:
                                            controller.colorHexMap[colorInt] ??
                                            Colors.grey,
                                        colorName:
                                            controller.colorNameMap[colorInt] ??
                                            '?',
                                        borderColor:
                                            colorInt == 0
                                                ? Colors.grey.shade300
                                                : null,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kích thước",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:
                                  controller.availableSizes.map((sizeInt) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: _sizeOption(
                                        size:
                                            controller.sizeMap[sizeInt] ?? '?',
                                        sizeValue: sizeInt,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mô tả sản phẩm: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.description ?? 'Không có mô tả cho sản phẩm này.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.black.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Số lượng",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          _quantityButton(
                            icon: Icons.remove,
                            onTap: controller.decrementQuantity,
                            isEnabled: controller.selectedQuantity.value > 1,
                          ),
                          SizedBox(width: 12),
                          Text(
                            '${controller.selectedQuantity.value}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12),
                          _quantityButton(
                            icon: Icons.add,
                            onTap: controller.incrementQuantity,
                            isEnabled: controller.currentStock.value > 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.grey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Thanh toán ngay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: 10),
      ),
    );
  }

  Widget _sizeOption({required String size, required int sizeValue}) {
    return Obx(() {
      final isSelected = controller.selectedSize.value == sizeValue;
      final isAvailable = controller.availableSizes.contains(sizeValue);

      return GestureDetector(
        onTap: isAvailable ? () => controller.setSize(sizeValue) : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isAvailable ? 1.0 : 0.4,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isSelected
                      ? AppColor.primary.withAlpha(20)
                      : Colors.grey.shade100,
              border: Border.all(
                color: isSelected ? AppColor.primary : Colors.grey.shade400,
                width: 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColor.primary.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  color: isSelected ? AppColor.primary : AppColor.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  decoration:
                      isAvailable
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _colorOption({
    required int colorValue,
    required Color color,
    required String colorName,
    Color? borderColor,
  }) {
    return Obx(() {
      final isSelected = controller.selectedColor.value == colorValue;
      final isAvailable = controller.availableColors.contains(colorValue);

      return GestureDetector(
        onTap: isAvailable ? () => controller.setColor(colorValue) : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isAvailable ? 1.0 : 0.4,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
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
                    color: AppColor.primary.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child:
                isSelected
                    ? Icon(
                      Icons.check,
                      size: 16,
                      color:
                          color == Colors.white
                              ? AppColor.primary
                              : Colors.white,
                    )
                    : (isAvailable
                        ? null
                        : Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.black.withAlpha(100),
                        )),
          ),
        ),
      );
    });
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    Color buttonColor = isEnabled ? AppColor.primary : Colors.grey.shade400;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color:
              isEnabled ? AppColor.primary.withAlpha(20) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: buttonColor, width: 1.5),
          boxShadow: [
            if (isEnabled)
              BoxShadow(
                color: AppColor.primary.withAlpha(40),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Icon(icon, size: 18, color: buttonColor),
      ),
    );
  }
}
