import 'package:get/get.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Global/global_value.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/utils.dart';

class Auth {
  static backLogin(bool isRun) async {
    if (!isRun) {
      return null;
    }

    await Utils.saveStringWithKey(Constant.ACCESS_TOKEN, '');
    await Utils.saveStringWithKey(Constant.REFRESH_TOKEN, '');
    await Utils.saveStringWithKey(Constant.EMAIL, '');
    await Utils.saveStringWithKey(Constant.PASSWORD, '');
    if (Get.currentRoute != Routes.login) {
      Get.offAllNamed(Routes.login);
    }
  }

  static login({String? email, String? password}) async {
    String emailPreferences = await Utils.getStringValueWithKey(Constant.EMAIL);
    String passwordPreferences = await Utils.getStringValueWithKey(
      Constant.PASSWORD,
    );

    Map<String, String> param = {
      // "username": userName ?? userNamePreferences,
      // "password":
      //     password != null ? Utils.generateMd5(password) : passwordPreferences,
      "email": email ?? emailPreferences,
      "password": password ?? passwordPreferences,
    };

    try {
      var response = await APICaller.getInstance().post(
        'v1/auth/login',
        body: param,
      );
      if (response != null) {
        GlobalValue.getInstance().setToken(
          'Bearer ${response['tokens']['access_token']}',
        );

        Utils.saveStringWithKey(
          Constant.ACCESS_TOKEN,
          response['tokens']['access_token'],
        );
        Utils.saveStringWithKey(
          Constant.REFRESH_TOKEN,
          response['tokens']['refresh_token'],
        );

        // Utils.saveStringWithKey(Constant.NAME, response['data']['name'] ?? '');
        // Utils.saveStringWithKey(
        //   Constant.AVATAR,
        //   response['data']['avatar'] ?? '',
        // );

        Utils.saveStringWithKey(Constant.EMAIL, email ?? emailPreferences);
        Utils.saveStringWithKey(Constant.PASSWORD, param['password']!);
        Get.offAllNamed(Routes.dashboard);
      } else {
        backLogin(true);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }
}
