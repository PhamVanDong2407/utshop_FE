import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Models/Carts.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Global/constant.dart';

class CartController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UserCart?> cart = Rx<UserCart?>(null);
  final RxSet<String> selectedItems = <String>{}.obs;

  final Map<int, String> sizeMap = {0: 'M', 1: 'L', 2: 'XL'};
  final Map<int, String> colorNameMap = {0: 'Trắng', 1: 'Đỏ', 2: 'Đen'};
  final Map<int, Color> colorHexMap = {
    0: Colors.white,
    1: Colors.red,
    2: Colors.black,
  };

  @override
  void onInit() {
    super.onInit();
    getListCart();
  }

  Future<void> getListCart() async {
    try {
      isLoading.value = true;
      selectedItems.clear();

      var response = await APICaller.getInstance().get('v1/cart');

      if (response['code'] == 200) {
        final String baseUrl = Constant.BASE_URL_IMAGE;
        var responseData = response['data'] as Map<String, dynamic>;
        var rawItems = responseData['items'] as List<dynamic>?;

        List<Items> processedItems =
            (rawItems ?? []).map((itemJson) {
              final item = Items.fromJson(itemJson);
              final path = item.mainImageUrl;

              if (path?.isNotEmpty == true) {
                item.mainImageUrl =
                    path!.startsWith('http')
                        ? path
                        : path.startsWith('resources/')
                        ? '$baseUrl$path'
                        : '$baseUrl/$path';
              }

              return item;
            }).toList();

        cart.value = UserCart(
          items: processedItems,
          totalItems: responseData['total_items'],
          totalAmount: (responseData['total_amount'] as num?)?.toDouble(),
        );

        toggleSelectAll();
      } else {
        Get.snackbar(
          "Lỗi",
          response['message'] ?? "Không thể tải giỏ hàng",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error fetching cart list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(Items item) async {
    try {
      var response = await APICaller.getInstance().delete(
        'v1/cart/${item.variantUuid}',
      );
      if (response['code'] == 200) {
        getListCart();
        Get.snackbar(
          "Thành công",
          "Đã xóa '${item.productName}' khỏi giỏ hàng",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Lỗi",
          response['message'] ?? "Không thể xóa sản phẩm",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("Error removing from cart: $e");
    }
  }

  /// Tăng số lượng (Local)
  void incrementQuantity(Items item) {
    if (item.quantity == null || item.stock == null || item.price == null) {
      return;
    }

    // Kiểm tra tồn kho
    if (item.quantity! < item.stock!) {
      item.quantity = item.quantity! + 1;
      // Cập nhật subtotal của item này
      item.subtotal = item.price! * item.quantity!;

      // Báo cho UI (ListView) cập nhật
      cart.refresh();
      // Báo cho UI (CheckoutBar) cập nhật
      selectedItems.refresh();
    } else {
      // Thông báo đã đạt tối đa
      Get.snackbar(
        "Tồn kho",
        "Bạn đã chọn số lượng tối đa (${item.stock})",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange.withAlpha(100),
        colorText: Colors.black,
      );
    }
  }

  /// Giảm số lượng (Local)
  void decrementQuantity(Items item) {
    if (item.quantity == null || item.price == null) return;

    // Không cho giảm dưới 1
    if (item.quantity! > 1) {
      item.quantity = item.quantity! - 1;
      // Cập nhật subtotal
      item.subtotal = item.price! * item.quantity!;

      cart.refresh();
      selectedItems.refresh();
    }
  }

  bool isItemSelected(String variantUuid) {
    return selectedItems.contains(variantUuid);
  }

  void toggleItemSelection(String variantUuid) {
    if (isItemSelected(variantUuid)) {
      selectedItems.remove(variantUuid);
    } else {
      selectedItems.add(variantUuid);
    }
  }

  bool get isAllSelected {
    if (cart.value == null || cart.value!.items == null) return false;
    if (cart.value!.items!.isEmpty) return false; // Thêm check rỗng
    return selectedItems.length == cart.value!.items!.length;
  }

  void toggleSelectAll() {
    if (cart.value == null || cart.value!.items == null) return;

    if (isAllSelected) {
      selectedItems.clear();
    } else {
      for (var item in cart.value!.items!) {
        selectedItems.add(item.variantUuid!);
      }
    }
  }

  List<Items> get selectedCartItems {
    if (cart.value == null) return [];
    return cart.value!.items!
        .where((item) => isItemSelected(item.variantUuid!))
        .toList();
  }

  int get selectedItemCount {
    return selectedCartItems.length;
  }

  double get selectedTotalAmount {
    return selectedCartItems.fold(0.0, (sum, item) {
      return sum + (item.subtotal ?? 0.0);
    });
  }

  void showDeleteConfirmation(Items item) {
    Get.defaultDialog(
      title: "Xác nhận xóa",
      middleText: "Bạn có chắc muốn xóa ${item.productName} khỏi giỏ hàng?",
      textConfirm: "Xóa",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: AppColor.primary,
      onConfirm: () {
        Get.back();
        removeFromCart(item);
      },
    );
  }

  String formatCurrency(num? amount) {
    if (amount == null) return "0 ₫";
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(amount);
  }

  String getVariantText(Items item) {
    String color = colorNameMap[item.color] ?? 'Màu ${item.color}';
    String size = sizeMap[item.size] ?? 'Size ${item.size}';
    return "Phân loại: $color / $size";
  }
}
