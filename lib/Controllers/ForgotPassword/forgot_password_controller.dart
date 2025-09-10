import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class ForgotPasswordController extends GetxController {
  final email = TextEditingController();

  Future<void> forgotPassword() async {
    try {
      final body = {"email": email.text.trim()};

      final response = await APICaller.getInstance().post(
        "v1/forgot_password/forgot-password",
        body: body,
      );

      if (response != null) {
        Utils.showSnackBar(
          title: "Thành công",
          message:
              "Yêu cầu đặt lại mật khẩu đã được gửi, vui lòng kiểm tra email",
        );

        Get.toNamed(
          Routes.verifyForgotPassword,
          arguments: {"email": email.text.trim()},
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: "Lỗi", message: e.toString());
    }
  }
}
