import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Models/DeliveryAdress.dart';
import 'package:utshop/Models/Vouchers.dart';
import 'package:utshop/Models/Carts.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';
import '../../../Views/Cart/ConfirmOrder/vietqr_payment_sheet.dart';

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

  // Sản phẩm
  RxList<Items> itemsToCheckout = <Items>[].obs;

  // Tính toán
  var subtotalAmount = 0.0.obs;
  var shippingFee = 30000.0.obs; // Phí ship (ví dụ)
  var voucherDiscount = 0.0.obs;
  var totalAmount = 0.0.obs;

  // Biến loading cho nút đặt hàng
  var isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Nhận sản phẩm từ giỏ hàng
    if (Get.arguments != null && Get.arguments is List<Items>) {
      itemsToCheckout.value = Get.arguments;
      calculateTotals();
    } else {
      Get.back();
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Không tìm thấy sản phẩm để thanh toán.",
      );
    }

    // 2. Tải song song địa chỉ và voucher
    Future.wait([
      getListAddresses(),
      getListVouchers(),
      // ignore: body_might_complete_normally_catch_error
    ]).then((_) => isLoading.value = false).catchError((e) {
      isLoading.value = false;
      debugPrint("Lỗi khi tải dữ liệu ban đầu: $e");
    });

    // 3. Tự động tính lại tổng tiền khi voucher thay đổi
    ever(selectedVoucher, (_) => calculateTotals());
  }

  /// Tính toán tổng tiền
  void calculateTotals() {
    subtotalAmount.value = itemsToCheckout.fold(
      0.0,
      (sum, item) => sum + (item.subtotal ?? 0.0),
    );

    voucherDiscount.value = 0.0;
    final voucher = selectedVoucher.value;
    if (voucher != null && voucher.discountValue != null) {
      double discountValue = double.tryParse(voucher.discountValue!) ?? 0;
      if (voucher.discountType == 1) {
        voucherDiscount.value = discountValue;
      } else if (voucher.discountType == 2) {
        double percentage = discountValue / 100;
        double discount = subtotalAmount.value * percentage;
        double maxDiscount =
            double.tryParse(voucher.maxDiscountAmount ?? '0') ?? 0;
        if (maxDiscount > 0 && discount > maxDiscount) {
          discount = maxDiscount;
        }
        voucherDiscount.value = discount;
      }
    }
    totalAmount.value =
        (subtotalAmount.value + shippingFee.value) - voucherDiscount.value;
    if (totalAmount.value < 0) totalAmount.value = 0.0;
  }

  /// Format tiền tệ
  String formatCurrency(num? amount) {
    if (amount == null) return "0 ₫";
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Lấy text phân loại
  String getVariantText(Items item) {
    final Map<int, String> sizeMap = {0: 'M', 1: 'L', 2: 'XL'};
    final Map<int, String> colorNameMap = {0: 'Trắng', 1: 'Đỏ', 2: 'Đen'};
    String color = colorNameMap[item.color] ?? 'Màu ${item.color}';
    String size = sizeMap[item.size] ?? 'Size ${item.size}';
    return "Phân loại: $color / $size";
  }

  void selectPaymentMethod(PaymentMethod? method) {
    if (method != null) selectedPaymentMethod.value = method;
  }

  void selectAddress(DeliveryAdd newAddress) {
    selectedAddress.value = newAddress;
  }

  void selectVoucher(ListVouchers newVoucher) {
    selectedVoucher.value = newVoucher;
  }

  /// Hàm xử lý đặt hàng
  Future<void> processCheckout() async {
    if (isPlacingOrder.value) return;
    if (selectedAddress.value == null) {
      Utils.showSnackBar(
        title: "Thông báo",
        message: "Vui lòng chọn địa chỉ giao hàng",
      );
      return;
    }

    isPlacingOrder.value = true;
    try {
      Map<String, dynamic> orderPayload = {
        "address_uuid": selectedAddress.value!.uuid,
        "items":
            itemsToCheckout
                .map(
                  (item) => {
                    "variant_uuid": item.variantUuid,
                    "quantity": item.quantity,
                    "price": item.price,
                  },
                )
                .toList(),
        "voucher_uuid": selectedVoucher.value?.uuid,
        "subtotal": subtotalAmount.value,
        "shipping_fee": shippingFee.value,
        "discount": voucherDiscount.value,
        "total_amount": totalAmount.value,
        "payment_method":
            selectedPaymentMethod.value == PaymentMethod.cod ? "cod" : "vietqr",
      };

      final response = await APICaller.getInstance().post(
        "v1/order/create",
        body: orderPayload,
      );

      if (response != null &&
          (response['code'] == 201 || response['code'] == 200)) {
        final orderData = response['data'];
        final String orderCode = orderData['order_code'];
        final double orderTotal = (orderData['total_amount'] as num).toDouble();

        if (orderData['payment_method'] == "cod") {
          Get.offAllNamed(Routes.orderSuccess, arguments: orderCode);
        } else if (orderData['payment_method'] == "vietqr") {
          _showVietQRSheet(orderCode, orderTotal);
        }
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Tạo đơn hàng thất bại",
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: "Lỗi", message: "Đã có lỗi xảy ra: $e");
    } finally {
      isPlacingOrder.value = false;
    }
  }

  /// Hàm mở Bottom Sheet VietQR
  void _showVietQRSheet(String orderCode, double totalAmount) {
    const String myBankBin = "970422"; // Mã BIN của MB Bank
    const String myBankAccount = "0982788253"; // STK của bạn
    const String myAccountName = "PHAM VAN DONG"; // Tên chủ TK

    Get.bottomSheet(
      VietQRPaymentSheet(
        orderCode: orderCode,
        totalAmount: totalAmount,
        bankBin: myBankBin,
        bankAccount: myBankAccount,
        accountName: myAccountName,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
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
