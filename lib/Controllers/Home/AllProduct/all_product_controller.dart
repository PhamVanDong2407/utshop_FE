import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Models/popularProduct.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class AllProductController extends GetxController {
  RxString searchQuery = ''.obs;
  RxString selectedColor = "".obs;
  RxString selectedSize = ''.obs;
  RxInt selectedQuantity = 1.obs;
  final String baseUrl = Constant.BASE_URL_IMAGE;
    var isLoading = true.obs;

  // AllProduct
  RxList<ProductPopu> allProductList = <ProductPopu>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllProductList();
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
