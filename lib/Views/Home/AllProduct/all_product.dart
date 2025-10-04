import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Controllers/Home/PopularProduct/popular_product_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Routes/app_page.dart';

class AllProduct extends StatelessWidget {
  AllProduct({super.key});

  final controller = Get.put(PopularProductController());

  final List<Map<String, dynamic>> popularProducts = [
    {
      'name': 'Áo Thun Basic',
      'price': 150000,
      'image': 'assets/images/product1.png',
      'isFavorite': false.obs,
    },
    {
      'name': 'Quần Jeans Slim',
      'price': 399000,
      'image': 'assets/images/product2.png',
      'isFavorite': true.obs,
    },
    {
      'name': 'Váy Chữ A Xinh',
      'price': 280000,
      'image': 'assets/images/product3.png',
      'isFavorite': false.obs,
    },
    {
      'name': 'Áo Khoác Hoodie',
      'price': 550000,
      'image': 'assets/images/product4.png',
      'isFavorite': false.obs,
    },
    {
      'name': 'Giày Sneaker Trắng',
      'price': 720000,
      'image': 'assets/images/product5.png',
      'isFavorite': true.obs,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        foregroundColor: AppColor.white,
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: const Text(
          "Tất cả sản phẩm",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.50,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                ),
                itemBuilder: (context, index) {
                  final product =
                      popularProducts[index % popularProducts.length];
                  return _ProductCard(
                    name: product['name'],
                    price: product['price'],
                    imagePath: product['image'],
                    isFavorite: product['isFavorite'],
                    controller: controller,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String imagePath;
  final RxBool isFavorite;
  final PopularProductController controller;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.isFavorite,
    required this.controller,
  });

  String _formatPrice(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 160;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.productDetail);
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.0),
                  ),
                  child: Image.asset(
                    imagePath,
                    height: 180,
                    width: cardWidth,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: Center(child: Text("Ảnh lỗi")),
                        ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {
                        isFavorite.value = !isFavorite.value;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              isFavorite.value ? Colors.red : AppColor.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatPrice(price),
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        _showBuyBottomSheet(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Mua ngay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.0),
                    ),
                    child: Image.asset(
                      imagePath,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey[200],
                            child: Center(child: Text("Ảnh lỗi")),
                          ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "500.000 ₫",
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Kho: 26",
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "Màu sắc",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _colorOption(
                    color: Colors.white,
                    borderColor: Colors.grey.shade300,
                    colorName: 'Trắng',
                  ),
                  SizedBox(width: 16),
                  _colorOption(color: Colors.red, colorName: 'Đỏ'),
                  SizedBox(width: 16),
                  _colorOption(color: Colors.black, colorName: 'Đen'),
                ],
              ),
              SizedBox(height: 24),
              Text(
                "Kích thước",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _sizeOption(size: 'M'),
                  SizedBox(width: 16),
                  _sizeOption(size: 'L'),
                  SizedBox(width: 16),
                  _sizeOption(size: 'XL'),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Số lượng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        _quantityButton(
                          icon: Icons.remove,
                          onTap: controller.decrementQuantity,
                          isEnabled: controller.selectedQuantity.value > 1,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '${controller.selectedQuantity.value}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 16),
                        _quantityButton(
                          icon: Icons.add,
                          onTap: controller.incrementQuantity,
                          isEnabled: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _sizeOption({required String size}) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.setSize(size),
        child: AnimatedScale(
          scale: controller.selectedSize.value == size ? 1.1 : 1.0,
          duration: Duration(milliseconds: 200),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  controller.selectedSize.value == size
                      ? AppColor.primary.withAlpha(1)
                      : Colors.grey.shade100,
              border: Border.all(
                color:
                    controller.selectedSize.value == size
                        ? AppColor.primary
                        : Colors.grey.shade400,
                width: 2,
              ),
              boxShadow: [
                if (controller.selectedSize.value == size)
                  BoxShadow(
                    color: AppColor.primary.withAlpha(3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
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
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
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
          scale: isSelected ? 1.1 : 1.0,
          duration: Duration(milliseconds: 200),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColor.primary
                            : (borderColor ?? Colors.grey.shade400),
                    width: isSelected ? 3.0 : 1.5,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppColor.primary.withAlpha(3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                  ],
                ),
                child:
                    isSelected
                        ? Icon(
                          Icons.check,
                          size: 20,
                          color:
                              color == Colors.white
                                  ? AppColor.primary
                                  : Colors.white,
                        )
                        : null,
              ),
              SizedBox(height: 6),
              Text(
                colorName,
                style: TextStyle(
                  fontSize: 12,
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? AppColor.primary.withAlpha(1)
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: buttonColor, width: 1.5),
          boxShadow: [
            if (isEnabled)
              BoxShadow(
                color: AppColor.primary.withAlpha(2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Icon(icon, size: 20, color: buttonColor),
      ),
    );
  }
}
