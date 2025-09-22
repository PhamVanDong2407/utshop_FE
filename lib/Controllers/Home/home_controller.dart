import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeController extends GetxController {
  RxString name = ''.obs;
  RxString avatar = ''.obs;
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  @override
  void onInit() {
    super.onInit();
    Utils.getStringValueWithKey(Constant.NAME).then((value) {
      name.value = value;
    });
    Utils.getStringValueWithKey(Constant.AVATAR).then((value) {
      avatar.value = baseUrl + value;
    });
  }

  updateName(String name) {
    this.name.value = name;
  }

  updateAvatar(String avatar) {
    this.avatar.value = baseUrl + avatar;
  }
}
