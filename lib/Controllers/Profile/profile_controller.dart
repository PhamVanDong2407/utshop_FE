import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Utils/utils.dart';

class ProfileController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString avatar = ''.obs;
  final String baseUrl = Constant.BASE_URL_IMAGE;

  @override
  void onInit() async {
    super.onInit();
    Utils.getStringValueWithKey(Constant.NAME).then((value) {
      name.value = value ?? '';
    });
    Utils.getStringValueWithKey(Constant.AVATAR).then((value) {
      avatar.value = value ?? '';
    });
    Utils.getStringValueWithKey(Constant.EMAIL).then((value) {
      email.value = value ?? '';
    });
  }

  updateName(String name) {
    this.name.value = name;
  }

  updateEmail(String email) {
    this.email.value = email;
  }

  updateAvatar(String avatar) {
    this.avatar.value = avatar;
  }
}
