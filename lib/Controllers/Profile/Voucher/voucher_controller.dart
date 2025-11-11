import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Models/Vouchers.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class VoucherController extends GetxController {
  RxSet<String> expandedVoucherUuids = <String>{}.obs;

  var isLoading = true.obs;
  RxList<ListVouchers> voucherList = <ListVouchers>[].obs;

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    getListVouchers(isRefresh: false);
  }

  void toggleExpand(String uuid) {
    if (expandedVoucherUuids.contains(uuid)) {
      expandedVoucherUuids.remove(uuid);
    } else {
      expandedVoucherUuids.add(uuid);
    }
  }

  Future<void> getListVouchers({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
      } else {
        isLoading.value = true;
      }

      String apiUrl =
          'v1/voucher/user-list?page=${currentPage.value}&limit=$_limit';

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
        totalPages.value = pagination['totalPage'] ?? 1;
      }
    } catch (e) {
      debugPrint('Error fetching voucher list: $e');
      voucherList.clear();
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Có lỗi xảy ra khi tải dữ liệu: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }
}