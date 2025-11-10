import 'dart:async';

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
  Timer? _debounce; // Thêm biến này để chờ người dùng gõ xong

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
    getAllProductList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;

    // Hủy timer cũ nếu đang chạy
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Bắt đầu timer mới
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Chỉ gọi API sau khi người dùng ngừng gõ 500ms
      getAllProductList();
    });
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    // Gọi API để tải lại danh sách
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

  // Hàm này UI sẽ gọi, nó tự động cập nhật UI và gọi API
  void toggleFavorite(String productUuid, RxBool isFavorite) {
    // 1. Lấy trạng thái hiện tại
    bool currentStatus = isFavorite.value;

    // 2. Cập nhật UI ngay lập tức (icon sẽ đổi)
    isFavorite.value = !currentStatus;

    // 3. Cập nhật trạng thái này trong 2 danh sách gốc
    // (Quan trọng: Để tránh mất trạng thái khi cuộn)
    _updateFavoriteStatusInLists(productUuid, !currentStatus);

    // 4. Gọi API tương ứng
    if (currentStatus == true) {
      // Nó *đã* là yêu thích -> gọi API xóa
      removeFavorite(productUuid);
    } else {
      // Nó *chưa* là yêu thích -> gọi API thêm
      addFavorite(productUuid);
    }
  }

  // Hàm helper để cập nhật 2 list (tránh mất state khi cuộn)
  void _updateFavoriteStatusInLists(String productUuid, bool newStatus) {
    try {
      int popIndex = popularProductList.indexWhere(
        (p) => p.uuid == productUuid,
      );
      if (popIndex != -1) {
        popularProductList[popIndex].isFavorite = newStatus;
      }
    } catch (e) {
      debugPrint("Error updating popular list: $e");
    }

    try {
      int allIndex = allProductList.indexWhere((p) => p.uuid == productUuid);
      if (allIndex != -1) {
        allProductList[allIndex].isFavorite = newStatus;
      }
    } catch (e) {
      debugPrint("Error updating all list: $e");
    }
  }

  Future<void> refreshData() async {
    // Reset bộ lọc về mặc định
    selectedFilter.value = 'Tất cả';
    searchQuery.value = '';

    // Tải lại tất cả dữ liệu song song
    await Future.wait([
      getBannerList(),
      getPopularProductList(),
      getAllProductList(), // Tải lại danh sách với filter mặc định
    ]);
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
      // Xây dựng URL động
      String apiUrl = 'v1/product/user/list?';
      
      // Thêm keyword nếu có
      if (searchQuery.value.isNotEmpty) {
        apiUrl += 'keyword=${Uri.encodeComponent(searchQuery.value)}&';
      }
      
      // Thêm category nếu có (và không phải "Tất cả")
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

            product.isFavorite = (item['is_favorite'] == 1 || item['is_favorite'] == true);

            return product;
          }).toList();
    } catch (e) {
      debugPrint('Error: $e');
      allProductList.clear(); // Xóa danh sách nếu có lỗi
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
      Utils.showSnackBar(title: "Lỗi", message: "Đã xảy ra lỗi: $e");
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
      Utils.showSnackBar(title: "Lỗi", message: "Đã xảy ra lỗi: $e");
    }
  }
}
