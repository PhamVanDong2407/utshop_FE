import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Models/DeliveryAdress.dart';
import 'package:utshop/Models/Vouchers.dart';
import 'package:utshop/Models/Carts.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

enum PaymentMethod { cod, vietqr }

class ConfirmOrderController extends GetxController {
  var selectedPaymentMethod = PaymentMethod.cod.obs;
  var isLoading = true.obs;

  // Địa chỉ
  RxList<DeliveryAdd> addressList = <DeliveryAdd>[].obs;
  var selectedAddress = Rx<DeliveryAdd?>(null);
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoadingMore = false.obs;
  final int _limit = 10;

  // Vouchers
  RxList<ListVouchers> voucherList = <ListVouchers>[].obs;
  var selectedVoucher = Rx<ListVouchers?>(null);
  var currentPageVC = 1.obs;
  var totalPagesVC = 1.obs;
  final int _limitVC = 10;

  // --- SỬA ĐỔI CHÍNH ---
  // 1. Danh sách sản phẩm được truyền từ giỏ hàng
  RxList<Items> itemsToCheckout = <Items>[].obs;

  // 2. Các biến tính toán tổng tiền
  var subtotalAmount = 0.0.obs; // Tổng tiền hàng
  var shippingFee = 30000.0.obs; // Phí ship (ví dụ, bạn có thể thay đổi)
  var voucherDiscount = 0.0.obs; // Tiền giảm giá
  var totalAmount = 0.0.obs; // TỔNG CUỐI CÙNG
  // -----------------------

  @override
  void onInit() {
    super.onInit();

    // --- NHẬN DỮ LIỆU SẢN PHẨM TỪ GIỎ HÀNG ---
    if (Get.arguments != null && Get.arguments is List<Items>) {
      itemsToCheckout.value = Get.arguments;
      // Tính toán tổng tiền ngay sau khi có danh sách sản phẩm
      calculateTotals();
    } else {
      Get.back();
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Không tìm thấy sản phẩm để thanh toán.",
      );
    }
    // ----------------------------------------

    // Chạy song song 2 API
    Future.wait([getListAddresses(), getListVouchers()])
        .then((_) {
          isLoading.value = false;
        })
        .catchError((e) {
          isLoading.value = false;
          debugPrint("Lỗi khi tải dữ liệu ban đầu: $e");
        });

    // --- TỰ ĐỘNG TÍNH LẠI TỔNG KHI VOUCHER THAY ĐỔI ---
    ever(selectedVoucher, (_) => calculateTotals());
  }

  /// --- HÀM TÍNH TOÁN TỔNG TIỀN ---
  void calculateTotals() {
    // 1. Tính tổng tiền hàng (Subtotal)
    subtotalAmount.value = itemsToCheckout.fold(
      0.0,
      (sum, item) => sum + (item.subtotal ?? 0.0),
    );

    // 2. Tính tiền giảm giá từ Voucher
    voucherDiscount.value = 0.0; // Reset
    final voucher = selectedVoucher.value;
    if (voucher != null && voucher.discountValue != null) {
      double discountValue = double.tryParse(voucher.discountValue!) ?? 0;

      // Type 1: Giảm tiền cố định (VND)
      if (voucher.discountType == 1) {
        voucherDiscount.value = discountValue;
      }
      // Type 2: Giảm theo phần trăm (%)
      else if (voucher.discountType == 2) {
        double percentage = discountValue / 100;
        double discount = subtotalAmount.value * percentage;

        // Kiểm tra giảm tối đa (nếu có)
        double maxDiscount =
            double.tryParse(voucher.maxDiscountAmount ?? '0') ?? 0;
        if (maxDiscount > 0 && discount > maxDiscount) {
          discount = maxDiscount;
        }
        voucherDiscount.value = discount;
      }
    }

    // 3. Tính tổng cuối cùng
    totalAmount.value =
        (subtotalAmount.value + shippingFee.value) - voucherDiscount.value;

    // Đảm bảo tổng không bị âm
    if (totalAmount.value < 0) {
      totalAmount.value = 0.0;
    }
  }

  String formatCurrency(num? amount) {
    if (amount == null) return "0 ₫";
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String getVariantText(Items item) {
    final Map<int, String> sizeMap = {0: 'M', 1: 'L', 2: 'XL'};
    final Map<int, String> colorNameMap = {0: 'Trắng', 1: 'Đỏ', 2: 'Đen'};
    String color = colorNameMap[item.color] ?? 'Màu ${item.color}';
    String size = sizeMap[item.size] ?? 'Size ${item.size}';
    return "Phân loại: $color / $size";
  }

  void selectPaymentMethod(PaymentMethod? method) {
    if (method != null) {
      selectedPaymentMethod.value = method;
    }
  }

  void selectAddress(DeliveryAdd newAddress) {
    selectedAddress.value = newAddress;
  }

  void selectVoucher(ListVouchers newVoucher) {
    selectedVoucher.value = newVoucher;
    // calculateTotals() sẽ tự động chạy do `ever()`
  }

  Future<void> getListAddresses({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      isLoading.value = true;
    }

    try {
      String apiUrl =
          'v1/delivery_address?page=${currentPage.value}&limit=$_limit';
      final response = await APICaller.getInstance().get(apiUrl);

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Thông báo!",
          message: response?['message'] ?? "Không thể tải danh sách địa chỉ",
        );
        addressList.clear();
        selectedAddress.value = null;
        return;
      }

      final data = response['data'] as List<dynamic>?;
      final pagination = response['pagination'];
      final List<DeliveryAdd> newAddresses =
          (data ?? []).map((item) => DeliveryAdd.fromJson(item)).toList();

      if (isRefresh) {
        addressList.value = newAddresses;
      } else {
        addressList.assignAll(newAddresses);
      }

      if (addressList.isNotEmpty) {
        var defaultAddr = addressList.firstWhere(
          (addr) => addr.isDefault == 1,
          orElse: () => addressList.first,
        );
        // Chỉ tự động chọn nếu chưa có gì được chọn (để tôn trọng lựa chọn trước đó)
        if (selectedAddress.value == null) {
          selectedAddress.value = defaultAddr;
        }
      } else {
        selectedAddress.value = null;
      }

      if (pagination != null) {
        totalPages.value = pagination['totalPage'] ?? 1;
      }
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
      addressList.clear();
      selectedAddress.value = null;
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Có lỗi xảy ra khi tải dữ liệu: $e",
      );
    } finally {
      if (isRefresh) isLoading.value = false;
    }
  }

  Future<void> getListVouchers({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPageVC.value = 1;
      isLoading.value = true;
    }

    try {
      String apiUrl =
          'v1/voucher/user-list?page=${currentPageVC.value}&limit=$_limitVC';
      final response = await APICaller.getInstance().get(apiUrl);

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Thông báo!",
          message:
              response?['message'] ?? "Không thể tải danh sách mã giảm giá",
        );
        voucherList.clear();
        return;
      }

      final data = response['data'] as List<dynamic>?;
      final pagination = response['pagination'];
      final List<ListVouchers> newVouchers =
          (data ?? []).map((item) => ListVouchers.fromJson(item)).toList();

      if (isRefresh) {
        voucherList.value = newVouchers;
      } else {
        voucherList.assignAll(newVouchers);
      }

      if (pagination != null) {
        totalPagesVC.value = pagination['totalPage'] ?? 1;
      }
    } catch (e) {
      debugPrint('Error fetching voucher list: $e');
      voucherList.clear();
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Có lỗi xảy ra khi tải dữ liệu: $e",
      );
    } finally {
      if (isRefresh) isLoading.value = false;
    }
  }
}
