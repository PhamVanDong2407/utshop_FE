import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Models/DetailProduct.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Utils/utils.dart';

class ProductDetailController extends GetxController {
  late String uuid;

  var isLoading = true.obs;
  final String baseUrl = Constant.BASE_URL_IMAGE;

  var product = DetailProduct().obs;

  var currentPage = 0.obs;
  var isFavorite = false.obs;
  var selectedColor = (-1).obs; // -1 = chưa chọn
  var selectedSize = (-1).obs; // -1 = chưa chọn
  var selectedQuantity = 1.obs;
  var currentStock = 0.obs; // Tồn kho cho biến thể đã chọn

  // Danh sách các tùy chọn hợp lệ
  var availableSizes = <int>{}.obs;
  var availableColors = <int>{}.obs;

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
    // Lấy UUID từ trang trước
    uuid = Get.arguments['uuid'];
    getDetailProduct();
  }

  // Cập nhật vị trí slide ảnh
  void updatePage(int index) {
    currentPage.value = index;
  }

  // Cập nhật size đã chọn
  void setSize(int size) {
    if (selectedSize.value == size) {
      selectedSize.value = -1; // Bỏ chọn nếu nhấn lại
    } else {
      selectedSize.value = size;
    }
    _updateAvailableOptions();
  }

  // Cập nhật màu đã chọn
  void setColor(int color) {
    if (selectedColor.value == color) {
      selectedColor.value = -1; // Bỏ chọn nếu nhấn lại
    } else {
      selectedColor.value = color;
    }
    _updateAvailableOptions();
  }

  // Cập nhật các tùy chọn khả dụng dựa trên lựa chọn
  void _updateAvailableOptions() {
    final variants = product.value.variants ?? [];

    if (selectedSize.value != -1 && selectedColor.value == -1) {
      // Đã chọn Size, lọc ra Color khả dụng
      availableColors.value =
          variants
              .where((v) => v.size == selectedSize.value && (v.stock ?? 0) > 0)
              .map((v) => v.color!)
              .toSet();
    } else if (selectedSize.value == -1 && selectedColor.value != -1) {
      // Đã chọn Color, lọc ra Size khả dụng
      availableSizes.value =
          variants
              .where(
                (v) => v.color == selectedColor.value && (v.stock ?? 0) > 0,
              )
              .map((v) => v.size!)
              .toSet();
    } else if (selectedSize.value == -1 && selectedColor.value == -1) {
      // Chưa chọn gì, hiển thị tất cả
      _resetAvailableOptions();
    }

    _updateStock();
  }

  // Cập nhật tồn kho dựa trên size và màu đã chọn
  void _updateStock() {
    if (selectedSize.value != -1 && selectedColor.value != -1) {
      final variant = product.value.variants?.firstWhereOrNull(
        (v) => v.size == selectedSize.value && v.color == selectedColor.value,
      );
      currentStock.value = variant?.stock ?? 0;
    } else {
      // Nếu chưa chọn đủ, hiển thị tổng tồn kho
      currentStock.value = product.value.totalStock ?? 0;
    }
    // Reset số lượng mua nếu vượt quá tồn kho
    if (selectedQuantity.value > currentStock.value && currentStock.value > 0) {
      selectedQuantity.value = currentStock.value;
    } else if (currentStock.value == 0 && selectedQuantity.value > 1) {
      selectedQuantity.value = 1;
    }
  }

  // Đặt lại các tùy chọn về ban đầu
  void _resetAvailableOptions() {
    final variants = product.value.variants ?? [];
    availableSizes.value = variants.map((v) => v.size!).toSet();
    availableColors.value = variants.map((v) => v.color!).toSet();
  }

  // Tăng số lượng mua
  void incrementQuantity() {
    // Chỉ cho phép tăng nếu nhỏ hơn tồn kho
    int stock =
        (selectedSize.value != -1 && selectedColor.value != -1)
            ? currentStock.value
            : product.value.totalStock ?? 0;

    if (stock == 0) {
      selectedQuantity.value = 1;
      return;
    }

    if (selectedQuantity.value < stock) {
      selectedQuantity.value++;
    } else {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Đã đạt số lượng tồn kho tối đa!",
      );
    }
  }

  // Giảm số lượng mua
  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }

  // Định dạng tiền tệ
  String formatPrice(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Future<void> getDetailProduct() async {
    try {
      isLoading(true);
      final response = await APICaller.getInstance().get(
        'v1/product/user/detail/$uuid',
      );

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể tải chi tiết sản phẩm",
        );
        return;
      }

      product.value = DetailProduct.fromJson(response['data']);

      if (product.value.images != null) {
        for (var img in product.value.images!) {
          if (img.url != null && !img.url!.startsWith('http')) {
            img.url = baseUrl + img.url!;
          }
        }
      }

      isFavorite.value = product.value.isFavorite ?? false;

      currentStock.value = product.value.totalStock ?? 0;

      _resetAvailableOptions();
    } catch (e) {
      debugPrint('Error fetching product detail: $e');
      Utils.showSnackBar(title: "Lỗi", message: "Đã xảy ra lỗi: $e");
    } finally {
      isLoading(false);
    }
  }
}
