import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Models/popularProduct.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class PopularProductController extends GetxController {
  RxString searchQuery = ''.obs;
  RxString selectedColor = "".obs;
  RxString selectedSize = ''.obs;
  RxInt selectedQuantity = 1.obs;

  final String baseUrl = Constant.BASE_URL_IMAGE;

  // PopularProduct
  RxList<ProductPopu> popularProductList = <ProductPopu>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPopularProductList();
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

  Future<void> fetchPopularProducts() async {
    await getPopularProductList();
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
}
