import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class ChangePasswordController extends GetxController {
  RxBool obscureOldPassword = true.obs;
  RxBool obscureNewPassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;
  RxBool isLoading = false.obs;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  changePassword() async {
    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Mật khẩu mới và xác nhận mật khẩu không khớp!',
      );
      return;
    }

    isLoading.value = true;
    try {
      var param = {
        "oldPassword": Utils.generateMd5(oldPasswordController.text.trim()),
        "newPassword": Utils.generateMd5(newPasswordController.text.trim()),
      };

      final response = await APICaller.getInstance().put(
        'v1/auth/change-password',
        body: param,
      );

      if (response != null && response['code'] == 200) {
        Get.back();
        Utils.showSnackBar(
          title: 'Thành công!',
          message: response['message'] ?? 'Đổi mật khẩu thành công!',
        );
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response?['message'] ?? 'Đã có lỗi xảy ra!',
        );
      }
    } catch (e) {
      String errorMessage = 'Đã có lỗi xảy ra!';
      if (e.toString().contains('401')) {
        errorMessage = 'Mật khẩu cũ không chính xác!';
      } else if (e.toString().contains('400')) {
        errorMessage = 'Thiếu thông tin bắt buộc!';
      }
      Utils.showSnackBar(title: 'Lỗi', message: errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
