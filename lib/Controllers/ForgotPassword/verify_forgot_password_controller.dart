import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class VerifyForgotPasswordController extends GetxController {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments['email'];
  }

  Future<void> verifyOTP() async {
    if (formKey.currentState!.validate()) {
      try {
        final body = {"email": email, "otp": otpController.text.trim()};

        final response = await APICaller.getInstance().post(
          "v1/forgot_password/verify-forgot-password-otp",
          body: body,
        );

        if (response != null) {
          Utils.showSnackBar(
            title: "Thành công",
            message: response["message"] ?? "Xác minh OTP thành công!",
          );

          Get.offAllNamed(Routes.resetPassword, arguments: {"email": email});
        }
      } catch (e) {
        Utils.showSnackBar(title: "Lỗi", message: e.toString());
      }
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
