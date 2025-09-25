import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// Thêm import cho carousel_slider
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Controllers/Home/home_controller.dart';
import 'package:utshop/Global/app_color.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(HomeController());
  final double horizontalPadding = 20.0;

  // 1. Danh sách các đường dẫn ảnh banner
  final List<String> bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];

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
      body: ListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            // Phần thanh tìm kiếm sản phẩm
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => TextField(
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm sản phẩm...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        suffixIcon:
                            controller.searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey),
                                  onPressed: controller.clearSearch,
                                )
                                : null,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: AppColor.primary,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: AppColor.primary,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: AppColor.grey,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/boloc.svg',
                      height: 40,
                      width: 40,
                    ).paddingSymmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Phần bọc lọc nhanh
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.selectedFilter.value = 'Tất cả',
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.selectedFilter.value == 'Tất cả'
                              ? AppColor.primary
                              : Colors.grey[200],
                      foregroundColor:
                          controller.selectedFilter.value == 'Tất cả'
                              ? Colors.white
                              : AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Tất cả',
                      style: TextStyle(
                        color:
                            controller.selectedFilter.value == 'Tất cả'
                                ? Colors.white
                                : AppColor.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.selectedFilter.value = 'Nam',
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.selectedFilter.value == 'Nam'
                              ? AppColor.primary
                              : Colors.grey[200],
                      foregroundColor:
                          controller.selectedFilter.value == 'Nam'
                              ? Colors.white
                              : AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Nam',
                      style: TextStyle(
                        color:
                            controller.selectedFilter.value == 'Nam'
                                ? Colors.white
                                : AppColor.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.selectedFilter.value = 'Nữ',
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.selectedFilter.value == 'Nữ'
                              ? AppColor.primary
                              : Colors.grey[200],
                      foregroundColor:
                          controller.selectedFilter.value == 'Nữ'
                              ? Colors.white
                              : AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Nữ',
                      style: TextStyle(
                        color:
                            controller.selectedFilter.value == 'Nữ'
                                ? Colors.white
                                : AppColor.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.selectedFilter.value = 'Quần',
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.selectedFilter.value == 'Quần'
                              ? AppColor.primary
                              : Colors.grey[200],
                      foregroundColor:
                          controller.selectedFilter.value == 'Quần'
                              ? Colors.white
                              : AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Quần',
                      style: TextStyle(
                        color:
                            controller.selectedFilter.value == 'Quần'
                                ? Colors.white
                                : AppColor.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.selectedFilter.value = 'Áo',
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.selectedFilter.value == 'Áo'
                              ? AppColor.primary
                              : Colors.grey[200],
                      foregroundColor:
                          controller.selectedFilter.value == 'Áo'
                              ? Colors.white
                              : AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Áo',
                      style: TextStyle(
                        color:
                            controller.selectedFilter.value == 'Áo'
                                ? Colors.white
                                : AppColor.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Phần Banner
          CarouselSlider(
            options: CarouselOptions(
              height: 150.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.85,
              initialPage: 0,
              reverse: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
            items:
                bannerImages.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(i, fit: BoxFit.cover),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),

          SizedBox(height: 16),

          // Phần sản phẩm phổ biến
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sản phẩm phổ biến",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Xem tất cả",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Sản phẩm phổ biến
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...popularProducts.map(
                  (product) => _ProductCard(
                    name: product['name'],
                    price: product['price'],
                    imagePath: product['image'],
                    isFavorite: product['isFavorite'],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Phần tất cả sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tất cả sản phẩm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    minimumSize: Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Xem tất cả",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Phần tất cả sản phẩm
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              ),
              itemBuilder: (context, index) {
                final product = popularProducts[index % popularProducts.length];
                return _ProductCard(
                  name: product['name'],
                  price: product['price'],
                  imagePath: product['image'],
                  isFavorite: product['isFavorite'],
                );
              },
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String imagePath;
  final RxBool isFavorite;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.isFavorite,
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

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
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
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite.value ? Colors.red : AppColor.primary,
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
    );
  }
}
