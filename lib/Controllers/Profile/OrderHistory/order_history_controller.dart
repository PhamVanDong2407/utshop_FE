import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Models/OrderHistorys.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class OrderHistoryController extends GetxController {
  var isLoading = true.obs;
  RxList<OrderHis> orderList = <OrderHis>[].obs;

  final Map<int, String> sizeMap = {0: 'M', 1: 'L', 2: 'XL'};
  final Map<int, String> colorNameMap = {0: 'Trắng', 1: 'Đỏ', 2: 'Đen'};

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    try {
      isLoading(true);
      orderList.clear();

      final response = await APICaller.getInstance().get("v1/order");

      if (response != null && response['code'] == 200) {
        final List<dynamic> data = response['data'];
        final String baseUrl = Constant.BASE_URL_IMAGE;

        orderList.value =
            data.map((json) {
              final path = json['main_image_url'];
              if (path != null && path.isNotEmpty == true) {
                json['main_image_url'] =
                    path!.startsWith('http')
                        ? path
                        : path.startsWith('resources/')
                        ? '$baseUrl$path'
                        : '$baseUrl/$path';
              }

              json['total_amount'] = json['total_amount']?.toString() ?? '0';
              json['total_items_count'] =
                  json['total_items_count']?.toString() ?? '0';

              return OrderHis.fromJson(json);
            }).toList();
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể tải lịch sử đơn hàng.",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("Error fetching order history: $e");
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Đã có lỗi xảy ra: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }

  String getVariantText(OrderHis order) {
    String color = colorNameMap[order.color] ?? 'Màu ${order.color}';
    String size = sizeMap[order.size] ?? 'Size ${order.size}';
    return "$color / $size";
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
        return AppColor.primary;
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

  String getFormattedTotal(String? totalAmount) {
    if (totalAmount == null) return "0 ₫";
    final double amountValue = double.tryParse(totalAmount) ?? 0.0;
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amountValue);
  }
}
