import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Models/DeliveryAdress.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class DeliveryAddressController extends GetxController {
  var isLoading = true.obs;
  RxList<DeliveryAdd> addressList = <DeliveryAdd>[].obs;

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoadingMore = false.obs;
  final int _limit = 10;

  final recipientNameController = TextEditingController();
  final phoneController = TextEditingController();
  final provinceController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();
  var isDefault = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  @override
  void onClose() {
    recipientNameController.dispose();
    phoneController.dispose();
    provinceController.dispose();
    districtController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> fetchAddresses({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
      } else {
        isLoading.value = true;
      }

      String apiUrl =
          'v1/delivery_address?page=${currentPage.value}&limit=$_limit';

      final response = await APICaller.getInstance().get(apiUrl);

      if (response?['code'] != 200 || response?['data'] == null) {
        Utils.showSnackBar(
          title: "Thông báo!",
          message: response?['message'] ?? "Không thể tải danh sách địa chỉ",
        );
        addressList.clear();
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

      if (pagination != null) {
        totalPages.value = pagination['totalPage'] ?? 1;
      }
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
      addressList.clear();
      Utils.showSnackBar(
        title: "Lỗi",
        message: "Có lỗi xảy ra khi tải dữ liệu: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAddress() async {
    if (!_validateForm()) return;

    try {
      final Map<String, dynamic> body = {
        'recipient_name': recipientNameController.text,
        'phone': phoneController.text,
        'province': provinceController.text,
        'district': districtController.text,
        'address': addressController.text,
        'is_default': isDefault.value ? 1 : 0,
      };

      final response = await APICaller.getInstance().post(
        'v1/delivery_address',
        body: body,
      );

      if (response?['code'] == 201) {
        Get.back();
        Utils.showSnackBar(
          title: "Thành công",
          message: response?['message'] ?? "Đã thêm địa chỉ mới.",
        );
        clearFormControllers();
        await fetchAddresses(isRefresh: true);
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể thêm địa chỉ.",
        );
      }
    } catch (e) {
      debugPrint('Error adding address: $e');
      Utils.showSnackBar(title: "Lỗi máy chủ", message: "Có lỗi xảy ra: $e");
    }
  }

  Future<void> updateAddress(String addressUuid) async {
    if (!_validateForm()) return;

    try {
      final Map<String, dynamic> body = {
        'recipient_name': recipientNameController.text,
        'phone': phoneController.text,
        'province': provinceController.text,
        'district': districtController.text,
        'address': addressController.text,
        'is_default': isDefault.value ? 1 : 0,
      };

      final response = await APICaller.getInstance().put(
        'v1/delivery_address/$addressUuid',
        body: body,
      );

      if (response?['code'] == 200) {
        Get.back();
        Utils.showSnackBar(
          title: "Thành công",
          message: response?['message'] ?? "Đã cập nhật địa chỉ.",
        );
        clearFormControllers();
        await fetchAddresses(isRefresh: true);
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể cập nhật địa chỉ.",
        );
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
      Utils.showSnackBar(title: "Lỗi máy chủ", message: "Có lỗi xảy ra: $e");
    }
  }

  Future<void> deleteAddress(String addressUuid) async {
    try {
      // [SỬA] Cập nhật API endpoint
      final response = await APICaller.getInstance().delete(
        'v1/delivery_address/$addressUuid',
      );

      if (response?['code'] == 200) {
        Utils.showSnackBar(
          title: "Thành công",
          message: response?['message'] ?? "Đã xóa địa chỉ.",
        );
        addressList.removeWhere((address) => address.uuid == addressUuid);
      } else {
        Utils.showSnackBar(
          title: "Lỗi",
          message: response?['message'] ?? "Không thể xóa địa chỉ.",
        );
      }
    } catch (e) {
      debugPrint('Error deleting address: $e');
      Utils.showSnackBar(title: "Lỗi máy chủ", message: "Có lỗi xảy ra: $e");
    }
  }

  void fillFormForEdit(DeliveryAdd address) {
    recipientNameController.text = address.recipientName ?? '';
    phoneController.text = address.phone ?? '';
    provinceController.text = address.province ?? '';
    districtController.text = address.district ?? '';
    addressController.text = address.address ?? '';
    isDefault.value = address.isDefault == 1;
  }

  void clearFormControllers() {
    recipientNameController.clear();
    phoneController.clear();
    provinceController.clear();
    districtController.clear();
    addressController.clear();
    isDefault.value = false;
  }

  bool _validateForm() {
    if (recipientNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        provinceController.text.isEmpty ||
        districtController.text.isEmpty ||
        addressController.text.isEmpty) {
      Utils.showSnackBar(
        title: "Thiếu thông tin",
        message: "Vui lòng điền đầy đủ các trường.",
      );
      return false;
    }
    return true;
  }
}
