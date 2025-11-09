import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Models/DetailProduct.dart'; // Import model chi tiết
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Utils/utils.dart';

/// Controller này chỉ dùng cho bottom sheet "Mua ngay" ở màn Home.
/// Nó sẽ tự tải chi tiết sản phẩm và tự hủy khi sheet đóng.
class QuickBuyController extends GetxController {
  // Dữ liệu ban đầu được truyền từ _ProductCard
  final String uuid;
  final String initialName;
  final String initialImage;
  final int initialPrice;

  // Trạng thái chung
  var isLoading = true.obs;
  final String baseUrl = Constant.BASE_URL_IMAGE;

  // Dữ liệu sản phẩm đầy đủ
  var product = DetailProduct().obs;

  // Trạng thái lựa chọn của người dùng
  var selectedColor = (-1).obs; // -1 = chưa chọn
  var selectedSize = (-1).obs; // -1 = chưa chọn
  var selectedQuantity = 1.obs;
  var currentStock = 0.obs; // Tồn kho cho biến thể đã chọn

  // Danh sách các tùy chọn hợp lệ
  var availableSizes = <int>{}.obs;
  var availableColors = <int>{}.obs;

  // Maps để chuyển đổi dữ liệu từ API (int) sang UI (String/Color)
  final Map<int, String> sizeMap = {0: 'M', 1: 'L', 2: 'XL'};
  final Map<int, String> colorNameMap = {0: 'Trắng', 1: 'Đỏ', 2: 'Đen'};
  final Map<int, Color> colorHexMap = {
    0: Colors.white,
    1: Colors.red,
    2: Colors.black
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
    // 1. Gán dữ liệu ban đầu ngay lập tức để UI hiển thị
    // (Giúp UI không bị "nhảy" khi API tải xong)
    product.value = DetailProduct(
      name: initialName,
      price: initialPrice,
      images: [Images(url: initialImage, isMain: true)],
      totalStock: 0, // Sẽ được cập nhật ngay sau đây
    );
    currentStock.value = 0; // Đặt tạm = 0
    // 2. Gọi API để lấy chi tiết (variants, stock...)
    getDetailProduct();
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
    
    // Bắt đầu với tất cả các biến thể CÓ HÀNG
    var validVariants = variants.where((v) => (v.stock ?? 0) > 0).toList();
    
    var sizesWithStock = validVariants.map((v) => v.size!).toSet();
    var colorsWithStock = validVariants.map((v) => v.color!).toSet();

    // Lọc theo size đã chọn (nếu có)
    if (selectedSize.value != -1) {
      colorsWithStock = variants
          .where((v) => v.size == selectedSize.value && (v.stock ?? 0) > 0)
          .map((v) => v.color!)
          .toSet();
    }
    
    // Lọc theo màu đã chọn (nếu có)
    if (selectedColor.value != -1) {
      sizesWithStock = variants
          .where((v) => v.color == selectedColor.value && (v.stock ?? 0) > 0)
          .map((v) => v.size!)
          .toSet();
    }

    availableSizes.value = sizesWithStock;
    availableColors.value = colorsWithStock;

    _updateStock();
  }


  // Cập nhật tồn kho dựa trên size và màu đã chọn
  void _updateStock() {
    if (selectedSize.value != -1 && selectedColor.value != -1) {
      final variant = product.value.variants?.firstWhereOrNull((v) =>
          v.size == selectedSize.value && v.color == selectedColor.value);
      currentStock.value = variant?.stock ?? 0;

      // Thông báo nếu biến thể đã chọn hết hàng
      if (currentStock.value == 0) {
         Utils.showSnackBar(
          title: "Thông báo",
          message: "Phân loại này đã hết hàng!",
        );
      }

    } else {
      // Nếu chưa chọn đủ, hiển thị tổng tồn kho
      currentStock.value = product.value.totalStock ?? 0;
    }
    
    // Reset số lượng mua nếu vượt quá tồn kho
    if (selectedQuantity.value > currentStock.value && currentStock.value > 0) {
      selectedQuantity.value = currentStock.value;
    } else if (currentStock.value == 0) {
      selectedQuantity.value = 1; // Nếu tồn kho là 0, reset về 1
    }
  }

  // Đặt lại các tùy chọn về ban đầu (chỉ hiển thị các size/màu có hàng)
  void _resetAvailableOptions() {
    final variants = product.value.variants ?? [];
    availableSizes.value =
        variants.where((v) => (v.stock ?? 0) > 0).map((v) => v.size!).toSet();
    availableColors.value =
        variants.where((v) => (v.stock ?? 0) > 0).map((v) => v.color!).toSet();
  }

  // Tăng số lượng mua
  void incrementQuantity() {
     int stock = currentStock.value;

    // Bắt buộc chọn đủ phân loại
    if (selectedSize.value == -1 || selectedColor.value == -1) {
       Utils.showSnackBar(
          title: "Thông báo", message: "Vui lòng chọn đầy đủ phân loại!");
      return;
    }

    if (stock == 0) {
       Utils.showSnackBar(
          title: "Thông báo", message: "Phân loại này đã hết hàng!");
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

  // Hàm gọi API
  Future<void> getDetailProduct() async {
    try {
      isLoading(true);
      final response = await APICaller.getInstance().get(
        'v1/product/user/detail/$uuid',
      );

      if (response?['code'] != 200 || response?['data'] == null) {
        debugPrint("Lỗi tải chi tiết: ${response?['message']}");
        // Giữ lại data ban đầu nhưng báo hết hàng
        product.value.totalStock = 0;
        currentStock.value = 0;
        _resetAvailableOptions();
        return;
      }

      final detail = DetailProduct.fromJson(response['data']);

      // Xử lý thêm baseUrl cho URL ảnh (chỉ cho ảnh chính)
      if (detail.images != null && detail.images!.isNotEmpty) {
        final mainImage = detail.images!.firstWhereOrNull((img) => img.isMain == true);
        String? finalImageUrl = initialImage; // Mặc định là ảnh từ list
        
        if (mainImage != null && mainImage.url != null) {
           finalImageUrl = mainImage.url!.startsWith('http')
                ? mainImage.url!
                : baseUrl + mainImage.url!;
        }
        // Ghi đè list ảnh chỉ với 1 ảnh chính (vì bottom sheet chỉ cần 1 ảnh)
        detail.images = [Images(url: finalImageUrl, isMain: true)];
      } else {
         // Đảm bảo vẫn có ảnh (ảnh từ list)
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
}