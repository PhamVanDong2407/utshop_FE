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
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('uuid')) {
      uuid = arguments['uuid'];
      getDetailProduct();
    } else {
      isLoading(false);
      Get.snackbar("Lỗi", "Không tìm thấy UUID sản phẩm.");
    }
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

    var sizesWithStock =
        variants.where((v) => (v.stock ?? 0) > 0).map((v) => v.size!).toSet();
    var colorsWithStock =
        variants.where((v) => (v.stock ?? 0) > 0).map((v) => v.color!).toSet();

    if (selectedSize.value != -1) {
      colorsWithStock =
          variants
              .where((v) => v.size == selectedSize.value && (v.stock ?? 0) > 0)
              .map((v) => v.color!)
              .toSet();
    }

    if (selectedColor.value != -1) {
      sizesWithStock =
          variants
              .where(
                (v) => v.color == selectedColor.value && (v.stock ?? 0) > 0,
              )
              .map((v) => v.size!)
              .toSet();
    }

    availableSizes.assignAll(sizesWithStock);
    availableColors.assignAll(colorsWithStock);

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
      currentStock.value = product.value.totalStock ?? 0;
    }
    if (selectedQuantity.value > currentStock.value && currentStock.value > 0) {
      selectedQuantity.value = currentStock.value;
    } else if (currentStock.value == 0 && selectedQuantity.value > 1) {
      selectedQuantity.value = 1;
    }
  }

  // Đặt lại các tùy chọn về ban đầu
  void _resetAvailableOptions() {
    final variants = product.value.variants ?? [];
    availableSizes.assignAll(variants.map((v) => v.size!).toSet());
    availableColors.assignAll(variants.map((v) => v.color!).toSet());
  }

  // Tăng số lượng mua
  void incrementQuantity() {
    int stock = currentStock.value;

    if (selectedSize.value == -1 || selectedColor.value == -1) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Vui lòng chọn đầy đủ phân loại!",
      );
      return;
    }

    if (stock == 0) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Phân loại này đã hết hàng!",
      );
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

  Future<void> addToCart() async {
    if (selectedColor.value == -1 || selectedSize.value == -1) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Vui lòng chọn đầy đủ màu sắc và kích cỡ.",
      );
      return;
    }

    if (currentStock.value == 0) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Phân loại này đã hết hàng.",
      );
      return;
    }

    final selectedVariant = product.value.variants?.firstWhereOrNull(
      (v) => v.color == selectedColor.value && v.size == selectedSize.value,
    );

    if (selectedVariant == null || selectedVariant.variantUuid == null) {
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Không tìm thấy biến thể sản phẩm này.",
      );
      return;
    }

    final body = {
      "variant_uuid": selectedVariant.variantUuid,
      "quantity": selectedQuantity.value,
    };

    try {
      final response = await APICaller.getInstance().post(
        'v1/cart',
        body: body,
      );

      if (response?['code'] == 200) {
        Utils.showSnackBar(
          title: "Thành công",
          message: response?['message'] ?? "Đã thêm vào giỏ hàng!",
        );
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể thêm vào giỏ.",
        );
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      Utils.showSnackBar(title: "Lỗi", message: "Đã xảy ra lỗi: $e");
    }
  }

  /// Hàm này UI sẽ gọi, nó tự động cập nhật UI và gọi API
  void toggleFavorite() {
    // 1. Lấy trạng thái hiện tại
    bool currentStatus = isFavorite.value;

    // 2. Cập nhật UI ngay lập tức (icon sẽ đổi)
    isFavorite.value = !currentStatus;

    // 3. Gọi API tương ứng
    if (currentStatus == true) {
      // Nó *đã* là yêu thích -> gọi API xóa
      removeFavorite(uuid);
    } else {
      // Nó *chưa* là yêu thích -> gọi API thêm
      addFavorite(uuid);
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
        isFavorite.value = false;
      }
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      Utils.showSnackBar(title: "Lỗi", message: "Đã xảy ra lỗi: $e");
      isFavorite.value = false;
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
        isFavorite.value = true;
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      Utils.showSnackBar(title: "Lỗi", message: "Đã xảy ra lỗi: $e");
      isFavorite.value = true;
    }
  }
}
