import 'dart:async';
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

  Timer? _debounce;
  RxString selectedFilter = 'Tất cả'.obs;

  RxList<ProductPopu> allProductList = <ProductPopu>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllProductList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getAllProductList();
    });
  }

  void clearSearch() {
    searchQuery.value = '';
    getAllProductList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    getAllProductList();
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
      isLoading.value = true;
      String apiUrl = 'v1/product/user/list?';

      if (searchQuery.value.isNotEmpty) {
        apiUrl += 'keyword=${Uri.encodeComponent(searchQuery.value)}&';
      }
      if (selectedFilter.value != 'Tất cả') {
        apiUrl += 'category=${Uri.encodeComponent(selectedFilter.value)}&';
      }

      final response = await APICaller.getInstance().get(apiUrl);

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Thông báo!",
          message: response?['message'] ?? "Không tìm thấy sản phẩm",
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

            product.isFavorite =
                (item['is_favorite'] == 1 || item['is_favorite'] == true);
            return product;
          }).toList();
    } catch (e) {
      debugPrint('Error: $e');
      allProductList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // === CÁC HÀM YÊU THÍCH ===

  void toggleFavorite(String productUuid, RxBool isFavorite) {
    bool currentStatus = isFavorite.value;
    isFavorite.value = !currentStatus;
    _updateFavoriteStatusInLists(productUuid, !currentStatus);

    if (currentStatus == true) {
      removeFavorite(productUuid);
    } else {
      addFavorite(productUuid);
    }
  }

  void _updateFavoriteStatusInLists(String productUuid, bool newStatus) {
    try {
      int allIndex = allProductList.indexWhere((p) => p.uuid == productUuid);
      if (allIndex != -1) {
        allProductList[allIndex].isFavorite = newStatus;
      }
    } catch (e) {
      debugPrint("Error updating all list: $e");
    }
  }

  Future<void> addFavorite(String productUuid) async {
    try {
      final Map<String, dynamic> body = {"product_uuid": productUuid};
      final response = await APICaller.getInstance().post(
        'v1/wishlist',
        body: body,
      );

      if (response?['code'] == 200) {
        Utils.showSnackBar(
          title: "Thành công",
          message: response?['message'] ?? "Đã thêm vào yêu thích.",
        );
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể thêm yêu thích.",
        );
      }
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(String productUuid) async {
    try {
      final response = await APICaller.getInstance().delete(
        'v1/wishlist/$productUuid',
      );

      if (response?['code'] == 200) {
        Utils.showSnackBar(
          title: "Thành công",
          message: response?['message'] ?? "Đã xóa khỏi yêu thích.",
        );
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể xóa yêu thích.",
        );
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }
}
