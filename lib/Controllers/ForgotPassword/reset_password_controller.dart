import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments['email'];
  }

  Future<void> resetPassword() async {
    try {
      final hashedPassword = Utils.generateMd5(passwordController.text.trim());
      final hashedConfirmPassword = Utils.generateMd5(
        confirmPasswordController.text.trim(),
      );
      final body = {
        "email": email,
        "password": hashedPassword,
        "confirmPassword": hashedConfirmPassword,
      };

      final response = await APICaller.getInstance().post(
        "v1/forgot_password/reset-password",
        body: body,
      );

      if (response != null) {
        Utils.showSnackBar(
          title: "Thành công",
          message: "Đặt lại mật khẩu thành công!",
        );

        Get.toNamed(Routes.login);
      }
    } catch (e) {
      Utils.showSnackBar(title: "Lỗi", message: e.toString());
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
