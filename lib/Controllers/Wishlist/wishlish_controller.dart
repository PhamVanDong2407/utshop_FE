import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Models/Wishlists.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class WishlishController extends GetxController {
  RxList<WishlistProduct> wishlistProduct = <WishlistProduct>[].obs;
  RxBool isLoading = false.obs;

  final String baseUrl = Constant.BASE_URL_IMAGE;

  @override
  void onInit() {
    super.onInit();
    getWishlist();
  }

  Future<void> getWishlist() async {
    try {
      isLoading.value = true;
      final response = await APICaller.getInstance().get('v1/wishlist');

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Lỗi",
          message:
              response?['message'] ??
              "Không thể tải danh sách sản phẩm yêu thích",
        );
        wishlistProduct.clear();
        return;
      }

      final data = response['data'] as List<dynamic>?;

      wishlistProduct.value =
          (data ?? []).map((item) {
            final product = WishlistProduct.fromJson(item);
            final path = product.imageUrl;

            if (path?.isNotEmpty == true) {
              final fullUrl =
                  path!.startsWith('http')
                      ? path
                      : path.startsWith('resources/')
                      ? '$baseUrl$path'
                      : '$baseUrl/$path';

              product.imageUrl = fullUrl;
            }

            return product;
          }).toList();
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeWishlist(String productUuid) async {
    try {
      wishlistProduct.removeWhere((p) => p.uuid == productUuid);

      final response = await APICaller.getInstance().delete(
        'v1/wishlist/$productUuid',
      );

      if (response?['code'] != 200) {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể xóa sản phẩm.",
        );
        getWishlist();
      } else {
        Utils.showSnackBar(
          title: "Thành công",
          message: "Đã xóa khỏi danh sách yêu thích.",
        );
      }
    } catch (e) {
      debugPrint('Error removing wishlist item: $e');
      getWishlist();
    }
  }
}
