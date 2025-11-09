import 'package:flutter_svg/svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Controllers/Home/home_controller.dart';
import 'package:utshop/Controllers/Home/quick_buy_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:get/get.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(HomeController());
  final double horizontalPadding = 20.0;

  Widget _buildBannerPlaceholder() {
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColor.primary),
          strokeWidth: 2,
        ),
      ),
    );
  }

  // Skeleton cho "Sản phẩm phổ biến" (Cuộn ngang)
  Widget _buildLoadingCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(children: List.generate(3, (_) => _ProductCardSkeleton())),
    );
  }

  // Skeleton cho "Tất cả sản phẩm" (Lưới)
  Widget _buildLoadingGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.56,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemBuilder: (context, index) => _GridCardSkeleton(),
      ),
    );
  }

  // Widget Skeleton cho thẻ (Cuộn ngang)
  // ignore: non_constant_identifier_names
  Widget _ProductCardSkeleton() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 100, color: Colors.grey[200]),
                SizedBox(height: 4),
                Container(height: 16, width: 60, color: Colors.grey[200]),
                SizedBox(height: 16),
                Container(height: 36, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Skeleton cho thẻ (Lưới)
  // ignore: non_constant_identifier_names
  Widget _GridCardSkeleton() {
    return Container(
      // <-- Không có width hay margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 100, color: Colors.grey[200]),
                SizedBox(height: 4),
                Container(height: 16, width: 60, color: Colors.grey[200]),
                SizedBox(height: 16),
                Container(height: 36, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PHẦN BUILD UI CHÍNH
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        color: AppColor.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(), // Luôn cho phép cuộn
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
                    () => GestureDetector(
                      onTap: () => controller.selectedFilter.value = 'Tất cả',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedFilter.value == 'Tất cả'
                                  ? AppColor.primary.withAlpha(1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                controller.selectedFilter.value == 'Tất cả'
                                    ? AppColor.primary
                                    : Colors.grey.shade300,
                            width:
                                controller.selectedFilter.value == 'Tất cả'
                                    ? 2
                                    : 1,
                          ),
                          boxShadow: [
                            if (controller.selectedFilter.value == 'Tất cả')
                              BoxShadow(
                                color: AppColor.primary.withAlpha(2),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/tatca.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: Center(child: Text('Lỗi')),
                                    ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tất cả',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    controller.selectedFilter.value == 'Tất cả'
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    controller.selectedFilter.value == 'Tất cả'
                                        ? AppColor.primary
                                        : AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.selectedFilter.value = 'Nam',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedFilter.value == 'Nam'
                                  ? AppColor.primary.withAlpha(1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                controller.selectedFilter.value == 'Nam'
                                    ? AppColor.primary
                                    : Colors.grey.shade300,
                            width:
                                controller.selectedFilter.value == 'Nam'
                                    ? 2
                                    : 1,
                          ),
                          boxShadow: [
                            if (controller.selectedFilter.value == 'Nam')
                              BoxShadow(
                                color: AppColor.primary.withAlpha(2),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/nam.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: Center(child: Text('Lỗi')),
                                    ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Nam',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    controller.selectedFilter.value == 'Nam'
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    controller.selectedFilter.value == 'Nam'
                                        ? AppColor.primary
                                        : AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.selectedFilter.value = 'Nữ',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedFilter.value == 'Nữ'
                                  ? AppColor.primary.withAlpha(1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                controller.selectedFilter.value == 'Nữ'
                                    ? AppColor.primary
                                    : Colors.grey.shade300,
                            width:
                                controller.selectedFilter.value == 'Nữ' ? 2 : 1,
                          ),
                          boxShadow: [
                            if (controller.selectedFilter.value == 'Nữ')
                              BoxShadow(
                                color: AppColor.primary.withAlpha(2),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/nu.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: Center(child: Text('Lỗi')),
                                    ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Nữ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    controller.selectedFilter.value == 'Nữ'
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    controller.selectedFilter.value == 'Nữ'
                                        ? AppColor.primary
                                        : AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.selectedFilter.value = 'Quần',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedFilter.value == 'Quần'
                                  ? AppColor.primary.withAlpha(1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                controller.selectedFilter.value == 'Quần'
                                    ? AppColor.primary
                                    : Colors.grey.shade300,
                            width:
                                controller.selectedFilter.value == 'Quần'
                                    ? 2
                                    : 1,
                          ),
                          boxShadow: [
                            if (controller.selectedFilter.value == 'Quần')
                              BoxShadow(
                                color: AppColor.primary.withAlpha(2),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/quan.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: Center(child: Text('Lỗi')),
                                    ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Quần',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    controller.selectedFilter.value == 'Quần'
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    controller.selectedFilter.value == 'Quần'
                                        ? AppColor.primary
                                        : AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.selectedFilter.value = 'Áo',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedFilter.value == 'Áo'
                                  ? AppColor.primary.withAlpha(1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                controller.selectedFilter.value == 'Áo'
                                    ? AppColor.primary
                                    : Colors.grey.shade300,
                            width:
                                controller.selectedFilter.value == 'Áo' ? 2 : 1,
                          ),
                          boxShadow: [
                            if (controller.selectedFilter.value == 'Áo')
                              BoxShadow(
                                color: AppColor.primary.withAlpha(2),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/ao.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: Center(child: Text('Lỗi')),
                                    ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Áo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    controller.selectedFilter.value == 'Áo'
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    controller.selectedFilter.value == 'Áo'
                                        ? AppColor.primary
                                        : AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Phần Banner
            SizedBox(height: 16),
            Obx(
              () =>
                  controller.bannerList.isEmpty
                      ? _buildBannerPlaceholder()
                      : CarouselSlider(
                        options: CarouselOptions(
                          height: 150.0,
                          autoPlay:
                              controller.bannerList.length >
                              1, // chỉ chạy khi có nhiều hơn 1 banner
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
                            controller.bannerList.map((banner) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        banner.imageUrl ?? '',
                                        fit: BoxFit.cover,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                      AppColor.primary,
                                                    ),
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.grey[200],
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
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
                    onPressed: () {
                      Get.toNamed(Routes.popularProduct);
                    },
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

            SizedBox(height: 16),

            // Sản phẩm phổ biến
            Obx(() {
              if (controller.popularProductList.isEmpty) {
                return _buildLoadingCards(); // Skeleton cuộn ngang
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      controller.popularProductList.map((product) {
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          child: _ProductCard(
                            uuid: product.uuid ?? '',
                            name: product.name ?? 'Không tên',
                            price: product.price ?? 0,
                            imagePath:
                                product.image ??
                                'assets/images/placeholder.png',
                            isFavorite: (product.isFavorite ?? false).obs,
                            controller: controller,
                          ),
                        );
                      }).toList(),
                ),
              );
            }),

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
                    onPressed: () {
                      Get.toNamed(Routes.allProduct);
                    },
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

            Obx(() {
              if (controller.allProductList.isEmpty) {
                return _buildLoadingGrid();
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.allProductList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.56,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.allProductList[index];
                    return _ProductCard(
                      uuid: product.uuid ?? '',
                      name: product.name ?? 'Không tên',
                      price: product.price ?? 0,
                      imagePath:
                          product.image ?? 'assets/images/placeholder.png',
                      isFavorite: (product.isFavorite ?? false).obs,
                      controller: controller,
                    );
                  },
                ),
              );
            }),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ==================== PRODUCT CARD WIDGET ====================

class _ProductCard extends StatelessWidget {
  final String uuid;
  final String name;
  final int price;
  final String imagePath;
  final RxBool isFavorite;
  final HomeController controller; // Vẫn dùng HomeController cho mục đích chung

  const _ProductCard({
    required this.uuid,
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
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.productDetail, arguments: {'uuid': uuid});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
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
                  child: Image.network(
                    imagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              AppColor.primary,
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
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
                          color: Colors.white.withAlpha(130),
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
                  Container(
                    height: 40.0,
                    alignment: Alignment.topLeft,
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
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
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      _showBuyBottomSheet(
                        context,
                        uuid,
                        name,
                        price,
                        imagePath,
                      );
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== BOTTOM SHEET  ====================
  void _showBuyBottomSheet(
    BuildContext context,
    String uuid,
    String initialName,
    int initialPrice,
    String initialImage,
  ) {
    Get.put(
      QuickBuyController(
        uuid: uuid,
        initialName: initialName,
        initialImage: initialImage,
        initialPrice: initialPrice,
      ),
      tag: uuid, // Tag duy nhất cho controller này
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.66,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            // 3. Dùng GetBuilder để kết nối với controller
            return GetBuilder<QuickBuyController>(
              tag: uuid, // Tìm đúng controller bằng tag
              builder: (qbc) {
                // 'qbc' là controller của chúng ta
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ẢNH VÀ GIÁ
                        Obx(
                          () => Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  qbc.product.value.images?.firstOrNull?.url ??
                                      initialImage,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        height: 120,
                                        width: 120,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Text("Ảnh lỗi"),
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      qbc.product.value.name ?? initialName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      qbc.formatPrice(
                                        qbc.product.value.price ?? initialPrice,
                                      ),
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Kho: ${qbc.currentStock.value}",
                                      style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Divider(height: 1, color: Colors.grey),
                        const SizedBox(height: 12),

                        // MÀU SẮC
                        const Text(
                          "Màu sắc",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (qbc.isLoading.value &&
                              qbc.availableColors.isEmpty) {
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.primary,
                              ),
                            );
                          }
                          if (qbc.availableColors.isEmpty &&
                              !qbc.isLoading.value) {
                            return Text("Sản phẩm không có phân loại màu.");
                          }
                          return Wrap(
                            spacing: 16.0, // Khoảng cách ngang
                            runSpacing: 8.0, // Khoảng cách dọc
                            children:
                                qbc.colorNameMap.entries
                                    .where(
                                      (entry) => qbc.availableColors.contains(
                                        entry.key,
                                      ),
                                    )
                                    .map((entry) {
                                      return _colorOption(
                                        controller: qbc,
                                        colorValue: entry.key,
                                        color:
                                            qbc.colorHexMap[entry.key] ??
                                            Colors.grey,
                                        colorName: entry.value,
                                        borderColor:
                                            entry.key == 0
                                                ? Colors.grey.shade300
                                                : null,
                                      );
                                    })
                                    .toList(),
                          );
                        }),

                        const SizedBox(height: 24),

                        // KÍCH THƯỚC
                        const Text(
                          "Kích thước",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (qbc.isLoading.value &&
                              qbc.availableSizes.isEmpty) {
                            return SizedBox(height: 48);
                          }
                          if (qbc.availableSizes.isEmpty &&
                              !qbc.isLoading.value) {
                            return Text(
                              "Sản phẩm không có phân loại kích thước.",
                            );
                          }
                          return Row(
                            children:
                                qbc.sizeMap.entries
                                    .where(
                                      (entry) => qbc.availableSizes.contains(
                                        entry.key,
                                      ),
                                    )
                                    .map((entry) {
                                      return _sizeOption(
                                        controller: qbc,
                                        size: entry.value,
                                        sizeValue: entry.key,
                                      );
                                    })
                                    .toList(),
                          );
                        }),

                        const SizedBox(height: 32),

                        // SỐ LƯỢNG
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Số lượng",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  _quantityButton(
                                    icon: Icons.remove,
                                    onTap: qbc.decrementQuantity,
                                    isEnabled: qbc.selectedQuantity.value > 1,
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${qbc.selectedQuantity.value}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  _quantityButton(
                                    icon: Icons.add,
                                    onTap: qbc.incrementQuantity,
                                    // Tắt nút cộng nếu chưa chọn biến thể hoặc đã hết hàng
                                    isEnabled:
                                        qbc.currentStock.value > 0 &&
                                        (qbc.selectedSize.value != -1 &&
                                            qbc.selectedColor.value != -1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // NÚT THÊM GIỎ
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Row(
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
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).then((_) {
      Get.delete<QuickBuyController>(tag: uuid);
    });
  }

  // --- WIDGETS CON CHO BOTTOM SHEET ---

  Widget _sizeOption({
    required QuickBuyController controller,
    required String size,
    required int sizeValue,
  }) {
    return Obx(() {
      final isSelected = controller.selectedSize.value == sizeValue;
      final isAvailable = controller.availableSizes.contains(sizeValue);

      return GestureDetector(
        onTap: isAvailable ? () => controller.setSize(sizeValue) : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isAvailable ? 1.0 : 0.3,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isSelected
                      ? AppColor.primary.withAlpha(20)
                      : Colors.grey.shade100,
              border: Border.all(
                color: isSelected ? AppColor.primary : Colors.grey.shade400,
                width: 2,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColor.primary.withAlpha(50),
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
                      isSelected
                          ? AppColor.primary
                          : (isAvailable ? AppColor.black : Colors.grey),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  // Thêm gạch ngang nếu không khả dụng
                  decoration: !isAvailable ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _colorOption({
    required QuickBuyController controller, // <-- SỬA: Dùng controller mới
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
          opacity: isAvailable ? 1.0 : 0.3,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
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
                          color: AppColor.primary.withAlpha(50),
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
                          : (!isAvailable // Nếu không có hàng
                              ? Icon(
                                Icons.close,
                                size: 20,
                                color:
                                    color == Colors.white
                                        ? Colors.black45
                                        : Colors.white60,
                              )
                              : null), // Nếu có hàng và không chọn
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
              isEnabled ? AppColor.primary.withAlpha(20) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
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
        child: Icon(icon, size: 20, color: buttonColor),
      ),
    );
  }
}
