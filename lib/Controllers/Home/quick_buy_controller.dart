import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Models/DetailProduct.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Utils/utils.dart';

class QuickBuyController extends GetxController {
  // Dữ liệu cơ bản được truyền vào từ Card sản phẩm (ở màn Home)
  final String uuid;
  final String initialName;
  final String initialImage;
  final int initialPrice;

  // Trạng thái chung
  var isLoading = true.obs;
  final String baseUrl = Constant.BASE_URL_IMAGE;

  // Dữ liệu sản phẩm đầy đủ (sẽ được tải từ API)
  var product = DetailProduct().obs;

  // Trạng thái lựa chọn hiện tại của người dùng
  var selectedColor = (-1).obs; // -1 = chưa chọn
  var selectedSize = (-1).obs; // -1 = chưa chọn
  var selectedQuantity = 1.obs;
  var currentStock = 0.obs; // Tồn kho cho biến thể đã chọn (Size + Màu)

  // Danh sách các tùy chọn size/màu CÒN HÀNG (dùng để lọc UI)
  var availableSizes = <int>{}.obs;
  var availableColors = <int>{}.obs;

  // Maps để "dịch" số từ API sang chữ/màu trên UI
  final Map<int, String> sizeMap = {0: 'M', 1: 'L', 2: 'XL'};
  final Map<int, String> colorNameMap = {0: 'Trắng', 1: 'Đỏ', 2: 'Đen'};
  final Map<int, Color> colorHexMap = {
    0: Colors.white,
    1: Colors.red,
    2: Colors.black,
  };

  QuickBuyController({
    required this.uuid,
    required this.initialName,
    required this.initialImage,
    required this.initialPrice,
  });

  @override
  void onInit() {
    super.onInit();
    // 1. Gán tạm dữ liệu ban đầu (tên, ảnh, giá) để UI hiển thị ngay lập tức
    //    (Giúp UI không bị "nhảy" khi API tải xong)
    product.value = DetailProduct(
      name: initialName,
      price: initialPrice,
      images: [Images(url: initialImage, isMain: true)],
      totalStock: 0, // Sẽ được cập nhật ngay sau đây
    );
    currentStock.value = 0; // Đặt tạm = 0
    getDetailProduct();
  }

  // Cập nhật size người dùng chọn
  void setSize(int size) {
    if (selectedSize.value == size) {
      selectedSize.value = -1; // Bỏ chọn nếu nhấn lại
    } else {
      selectedSize.value = size;
    }
    _updateAvailableOptions(); // Cập nhật lại các tùy chọn (lọc chéo)
  }

  // Cập nhật màu người dùng chọn
  void setColor(int color) {
    if (selectedColor.value == color) {
      selectedColor.value = -1; // Bỏ chọn nếu nhấn lại
    } else {
      selectedColor.value = color;
    }
    _updateAvailableOptions(); // Cập nhật lại các tùy chọn (lọc chéo)
  }

  // Cập nhật các tùy chọn khả dụng (lọc chéo)
  // Ví dụ: Nếu chọn Size M, chỉ hiển thị các Màu CÒN HÀNG cho Size M
  void _updateAvailableOptions() {
    final variants = product.value.variants ?? [];

    // Bắt đầu với tất cả các biến thể CÓ HÀNG
    var validVariants = variants.where((v) => (v.stock ?? 0) > 0).toList();

    // Lấy tất cả size/màu CÓ HÀNG (chưa lọc)
    var sizesWithStock = validVariants.map((v) => v.size!).toSet();
    var colorsWithStock = validVariants.map((v) => v.color!).toSet();

    // Lọc theo size đã chọn (nếu có)
    if (selectedSize.value != -1) {
      // Chỉ lấy các màu CÓ HÀNG ứng với size đã chọn
      colorsWithStock =
          variants
              .where((v) => v.size == selectedSize.value && (v.stock ?? 0) > 0)
              .map((v) => v.color!)
              .toSet();
    }

    // Lọc theo màu đã chọn (nếu có)
    if (selectedColor.value != -1) {
      // Chỉ lấy các size CÓ HÀNG ứng với màu đã chọn
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

    _updateStock(); // Cập nhật lại số tồn kho
  }

  // Cập nhật số lượng tồn kho (currentStock) dựa trên lựa chọn
  void _updateStock() {
    // Nếu người dùng đã chọn đủ cả size và màu
    if (selectedSize.value != -1 && selectedColor.value != -1) {
      // Tìm biến thể (variant) tương ứng
      final variant = product.value.variants?.firstWhereOrNull(
        (v) => v.size == selectedSize.value && v.color == selectedColor.value,
      );
      // Lấy tồn kho của riêng biến thể đó
      currentStock.value = variant?.stock ?? 0;

      // Thông báo nếu biến thể này hết hàng
      if (currentStock.value == 0) {
        Utils.showSnackBar(
          title: "Thông báo",
          message: "Phân loại này đã hết hàng!",
        );
      }
    } else {
      // Nếu chưa chọn đủ, hiển thị tổng tồn kho của sản phẩm
      currentStock.value = product.value.totalStock ?? 0;
    }

    // Reset số lượng mua nếu lỡ chọn vượt quá tồn kho
    if (selectedQuantity.value > currentStock.value && currentStock.value > 0) {
      selectedQuantity.value = currentStock.value;
    } else if (currentStock.value == 0) {
      selectedQuantity.value = 1; // Nếu tồn kho là 0, reset về 1
    }
  }

  // Đặt lại các tùy chọn về ban đầu (chỉ hiển thị các size/màu có hàng)
  void _resetAvailableOptions() {
    final variants = product.value.variants ?? [];

    availableSizes.assignAll(
      variants.where((v) => (v.stock ?? 0) > 0).map((v) => v.size!).toSet(),
    );
    availableColors.assignAll(
      variants.where((v) => (v.stock ?? 0) > 0).map((v) => v.color!).toSet(),
    );
  }

  // Tăng số lượng (cập nhật local, không gọi API)
  void incrementQuantity() {
    int stock = currentStock.value;

    // Bắt buộc chọn đủ phân loại
    if (selectedSize.value == -1 || selectedColor.value == -1) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Vui lòng chọn đầy đủ phân loại!",
      );
      return;
    }

    // Báo hết hàng
    if (stock == 0) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Phân loại này đã hết hàng!",
      );
      selectedQuantity.value = 1;
      return;
    }

    // Tăng nếu chưa đạt tối đa
    if (selectedQuantity.value < stock) {
      selectedQuantity.value++;
    } else {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Đã đạt số lượng tồn kho tối đa!",
      );
    }
  }

  // Giảm số lượng (cập nhật local)
  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }

  // Helper định dạng tiền tệ
  String formatPrice(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Tải dữ liệu chi tiết (bao gồm TẤT CẢ variants) từ API
  Future<void> getDetailProduct() async {
    try {
      isLoading(true);
      final response = await APICaller.getInstance().get(
        'v1/product/user/detail/$uuid',
      );

      // Nếu API lỗi hoặc không có data
      if (response?['code'] != 200 || response?['data'] == null) {
        debugPrint("Lỗi tải chi tiết: ${response?['message']}");
        product.value.totalStock = 0;
        currentStock.value = 0;
        _resetAvailableOptions();
        return;
      }

      // Parse data thành model
      final detail = DetailProduct.fromJson(response['data']);

      // Xử lý URL ảnh (chỉ lấy ảnh chính)
      if (detail.images != null && detail.images!.isNotEmpty) {
        final mainImage = detail.images!.firstWhereOrNull(
          (img) => img.isMain == true,
        );
        String? finalImageUrl = initialImage; // Mặc định là ảnh từ list

        if (mainImage != null && mainImage.url != null) {
          finalImageUrl =
              mainImage.url!.startsWith('http')
                  ? mainImage.url!
                  : baseUrl + mainImage.url!;
        }
        // Ghi đè list ảnh (chỉ cần 1 ảnh cho bottom sheet)
        detail.images = [Images(url: finalImageUrl, isMain: true)];
      } else {
        // Đảm bảo vẫn có ảnh (lấy ảnh từ list)
        detail.images = [Images(url: initialImage, isMain: true)];
      }

      // Gán dữ liệu chi tiết
      product.value = detail;
      currentStock.value = product.value.totalStock ?? 0;
      _resetAvailableOptions(); // Cập nhật size/màu có sẵn
    } catch (e) {
      debugPrint('Error fetching quick buy detail: $e');
    } finally {
      isLoading(false);
    }
  }

  // Thêm vào giỏ hàng (gọi API)
  Future<void> addToCart() async {
    // 1. Kiểm tra xem đã chọn màu sắc và kích cỡ chưa
    if (selectedColor.value == -1 || selectedSize.value == -1) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Vui lòng chọn đầy đủ màu sắc và kích cỡ.",
      );
      return;
    }

    // 2. Kiểm tra tồn kho (dựa trên currentStock đã được cập nhật)
    if (currentStock.value == 0) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Phân loại này đã hết hàng.",
      );
      return;
    }

    // 3. Tìm biến thể (variant) được chọn để lấy UUID
    final selectedVariant = product.value.variants?.firstWhereOrNull(
      (v) => v.color == selectedColor.value && v.size == selectedSize.value,
    );

    // Dùng .variantUuid (vì model DetailProduct của bạn dùng tên này)
    if (selectedVariant == null || selectedVariant.variantUuid == null) {
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Không tìm thấy biến thể sản phẩm này.",
      );
      return;
    }

    // 4. Chuẩn bị body để gửi API
    final body = {
      "variant_uuid": selectedVariant.variantUuid,
      "quantity": selectedQuantity.value,
    };

    // 5. Gọi API POST 'v1/cart'
    try {
      final response = await APICaller.getInstance().post(
        'v1/cart', // Endpoint API giỏ hàng
        body: body,
      );

      if (response?['code'] == 200) {
        // 6. Thành công: Đóng bottom sheet và báo
        Get.back(); // Đóng bottom sheet
        Utils.showSnackBar(
          title: "Thành công",
          message: response?['message'] ?? "Đã thêm vào giỏ hàng!",
        );
      } else {
        // 7. Thất bại: Báo lỗi
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
}
