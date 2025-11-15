import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Models/DetailOrderHistorys.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class DetailOrderHistoryController extends GetxController {
  var isLoading = true.obs;
  var orderDetail = Rx<DetailOrderHis?>(null);

  late String orderUuid;

  final Map<int, String> sizeMap = {0: 'M', 1: 'L', 2: 'XL'};
  final Map<int, String> colorNameMap = {0: 'Trắng', 1: 'Đỏ', 2: 'Đen'};

  @override
  void onInit() {
    super.onInit();
    // 1. Lấy UUID từ màn hình trước
    if (Get.arguments != null) {
      orderUuid = Get.arguments as String;
      fetchOrderDetail();
    } else {
      Get.back();
      Utils.showSnackBar(title: "Lỗi", message: "Không tìm thấy mã đơn hàng.");
    }
  }

  Future<void> fetchOrderDetail() async {
    try {
      isLoading(true);
      final response = await APICaller.getInstance().get("v1/order/$orderUuid");

      if (response != null && response['code'] == 200) {
        Map<String, dynamic> data = response['data'];
        final String baseUrl = Constant.BASE_URL_IMAGE;

        if (data['items'] != null) {
          List<dynamic> itemsList = data['items'] as List;
          for (var itemJson in itemsList) {
            final path = itemJson['main_image_url'];
            if (path != null && path.isNotEmpty == true) {
              itemJson['main_image_url'] =
                  path!.startsWith('http')
                      ? path
                      : path.startsWith('resources/')
                      ? '$baseUrl$path'
                      : '$baseUrl/$path';
            }
          }
        }

        orderDetail.value = DetailOrderHis.fromJson(data);
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể tải chi tiết đơn hàng.",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("Error fetching order detail: $e");
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Đã có lỗi xảy ra: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }

  String getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Đang xử lý';
      case 'awaiting_payment':
        return 'Chờ thanh toán';
      case 'paid':
        return 'Đã thanh toán';
      case 'shipping':
        return 'Đang giao';
      case 'delivered':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      case 'refunded':
        return 'Đã hoàn tiền';
      default:
        return 'Không rõ';
    }
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'pending':
      case 'awaiting_payment':
        return Colors.orange;
      case 'paid':
      case 'shipping':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
      case 'refunded':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatCurrency(String? amountStr) {
    if (amountStr == null) return "0 ₫";
    final double amountValue = double.tryParse(amountStr) ?? 0.0;
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amountValue);
  }

  String getVariantText(Items item) {
    String color = colorNameMap[item.color] ?? 'Màu ${item.color}';
    String size = sizeMap[item.size] ?? 'Size ${item.size}';
    return "$color / $size";
  }

  String getFormattedDate(String? isoString) {
    if (isoString == null) return "--";
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(isoString));
    } catch (e) {
      return "--";
    }
  }

  String getFormattedTime(String? isoString) {
    if (isoString == null) return "--";
    try {
      return DateFormat('HH:mm').format(DateTime.parse(isoString));
    } catch (e) {
      return "--";
    }
  }
}
