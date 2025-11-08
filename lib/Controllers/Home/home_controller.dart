import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Models/banners.dart';
import 'package:utshop/Models/popularProduct.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class HomeController extends GetxController {
  RxString name = ''.obs;
  RxString avatar = ''.obs;
  final String baseUrl = Constant.BASE_URL_IMAGE;
  RxString searchQuery = ''.obs;
  RxString selectedFilter = 'Tất cả'.obs;
  RxString selectedColor = "".obs;
  RxString selectedSize = ''.obs;
  RxInt selectedQuantity = 1.obs;

  // Banner
  RxList<Banners> bannerList = <Banners>[].obs;

  // PopularProduct
  RxList<ProductPopu> popularProductList = <ProductPopu>[].obs;

  // AllProduct
  RxList<ProductPopu> allProductList = <ProductPopu>[].obs;

  @override
  void onInit() {
    super.onInit();
    Utils.getStringValueWithKey(Constant.NAME).then((value) {
      name.value = value;
    });
    Utils.getStringValueWithKey(Constant.AVATAR).then((value) {
      avatar.value = baseUrl + value;
    });
    getBannerList();
    getPopularProductList();
    getAllProductList();
  }

  updateName(String name) {
    this.name.value = name;
  }

  updateAvatar(String avatar) {
    this.avatar.value = baseUrl + avatar;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void setSize(String size) {
    selectedSize.value = size;
  }

  void incrementQuantity() {
    selectedQuantity.value++;
  }

  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }

  Future<void> refreshData() async {
    getBannerList();
    getPopularProductList();
    getAllProductList();
  }

  Future<void> getBannerList() async {
    try {
      final response = await APICaller.getInstance().get('v1/banner');
      final data = response?['data'] as List<dynamic>?;

      bannerList.value =
          (data ?? []).map((item) {
            final banner = Banners.fromJson(item);
            final path = banner.imageUrl;

            if (path?.isNotEmpty == true) {
              banner.imageUrl =
                  path!.startsWith('http')
                      ? path
                      : path.startsWith('resources/')
                      ? '$baseUrl$path'
                      : '$baseUrl/$path';
            }

            return banner;
          }).toList();
    } catch (e) {
      debugPrint('Error fetching banner list: $e');
    }
  }

  Future<void> getPopularProductList() async {
    try {
      final response = await APICaller.getInstance().get(
        'v1/product/user/popular',
      );

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Thông báo!",
          message: "Không tìm thấy sản phẩm",
        );
        popularProductList.clear();
        return;
      }

      final data = response['data'] as List<dynamic>?;

      popularProductList.value =
          (data ?? []).map((item) {
            final product = ProductPopu.fromJson(item);
            final path = product.image;

            if (path?.isNotEmpty == true) {
              final fullUrl =
                  path!.startsWith('http')
                      ? path
                      : path.startsWith('resources/')
                      ? '$baseUrl$path'
                      : '$baseUrl/$path';

              product.image = fullUrl;
            }

            return product;
          }).toList();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> getAllProductList() async {
    try {
      final response = await APICaller.getInstance().get(
        'v1/product/user/list',
      );

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Thông báo!",
          message: "Không tìm thấy sản phẩm",
        );
        allProductList.clear();
        return;
      }

      final data = response['data'] as List<dynamic>?;

      allProductList.value =
          (data ?? []).map((item) {
            final product = ProductPopu.fromJson(item);
            final path = product.image;

            if (path?.isNotEmpty == true) {
              final fullUrl =
                  path!.startsWith('http')
                      ? path
                      : path.startsWith('resources/')
                      ? '$baseUrl$path'
                      : '$baseUrl/$path';

              product.image = fullUrl;
            }

            return product;
          }).toList();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
