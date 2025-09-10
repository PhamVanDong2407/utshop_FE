import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Services/auth.dart';
import 'package:utshop/Utils/utils.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 3));
    String accessToken = await Utils.getStringValueWithKey(
      Constant.ACCESS_TOKEN,
    );
    if (accessToken.isEmpty) {
      Get.offAllNamed(Routes.introduce);
    } else {
      await Auth.login();
    }
  }
}
