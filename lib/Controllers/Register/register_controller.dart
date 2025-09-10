import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';
import 'package:utshop/Routes/app_page.dart';

class RegisterController extends GetxController {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final phone = TextEditingController();

  var isPasswordHidden = true.obs;
  var agreed = false.obs;

  Future<void> register() async {
    try {
      final hashedPassword = Utils.generateMd5(password.text.trim());
      final body = {
        "name": fullName.text.trim(),
        "email": email.text.trim(),
        "password": hashedPassword,
        "phone": phone.text.trim(),
      };

      final response = await APICaller.getInstance().post(
        "v1/auth/register",
        body: body,
      );

      if (response != null) {
        Utils.showSnackBar(
          title: "Thành công",
          message: "Đăng ký thành công, vui lòng kiểm tra OTP",
        );

        Get.toNamed(
          Routes.verifyRegister,
          arguments: {"email": email.text.trim()},
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: "Lỗi", message: e.toString());
    }
  }

  void loginWithGoogle() {
    Utils.showSnackBar(
      title: "Thông báo",
      message: "Chức năng Google chưa làm 😁",
    );
  }
}
