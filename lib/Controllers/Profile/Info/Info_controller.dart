import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:utshop/Controllers/Home/home_controller.dart';
import 'package:utshop/Controllers/Profile/profile_controller.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Models/user.dart';
import 'package:utshop/Services/api_caller.dart';
import 'package:utshop/Utils/time_helper.dart';
import 'package:utshop/Utils/utils.dart';

class InfoController extends GetxController {
  RxBool isWaitSubmit = false.obs;
  Rx<File> avatarLocal = Rx<File>(File(''));
  RxString avatar = ''.obs;
  RxInt gender = (-1).obs; // 0: Nam, 1: Nữ
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  User detail = User();
  final String baseUrlImg = Constant.BASE_URL_IMAGE;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthDay = TextEditingController();
  TextEditingController createAt = TextEditingController();
  TextEditingController updatedAt = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getDetail();
  }

  getDetail() {
    isWaitSubmit.value = true;
    try {
      APICaller.getInstance().get("v1/user/me").then((value) {
        isWaitSubmit.value = false;
        if (value != null) {
          detail = User.fromJson(value['data']);
          _setValue();
        }
      });
    } catch (e) {
      isWaitSubmit.value = false;
      Utils.showSnackBar(title: 'Error!', message: 'Đã có lỗi xảy ra:\n$e!');
    }
  }

  _setValue() {
    avatar.value = detail.avatar ?? '';
    name.text = detail.name ?? '';
    phone.text = detail.phone ?? '';
    email.text = detail.email ?? '';
    province.text = detail.province ?? '';
    district.text = detail.district ?? '';
    address.text = detail.address ?? '';
    birthDay.text = TimeHelper.convertDateFormat(detail.birthDay, false);
    gender.value = detail.gender ?? -1;
    createAt.text = TimeHelper.convertDateFormat(detail.createdAt, false);
    updatedAt.text = TimeHelper.convertDateFormat(detail.updatedAt, false);
  }

  submit() {
    isWaitSubmit.value = true;
    try {
      final body = {
        "name": name.text.trim(),
        "phone": phone.text.trim(),
        "email": email.text.trim(),
        "province": province.text.trim(),
        "district": district.text.trim(),
        "address": address.text.trim(),
        "gender": gender.value,
      };

      if (birthDay.text.isNotEmpty && birthDay.text != "--") {
        body["birth_day"] = TimeHelper.convertDateFormat(birthDay.text, true);
      }

      if (avatarLocal.value.path.isEmpty) {
        APICaller.getInstance().put('v1/user/me', body: body).then((response) {
          isWaitSubmit.value = false;

          _afterUpdate(response, null);
        });
      } else {
        APICaller.getInstance().postFile(file: avatarLocal.value).then((value) {
          final filePath = value['file'];
          body['avatar'] = filePath;

          APICaller.getInstance().put('v1/user/me', body: body).then((respone) {
            isWaitSubmit.value = false;

            if (respone == null) {
              APICaller.getInstance().delete('v1/file/$filePath');
            } else {
              _afterUpdate(respone, filePath);
            }
          });
        });
      }
    } catch (e) {
      isWaitSubmit.value = false;
      debugPrint("submit error: $e");
      Utils.showSnackBar(title: 'Error!', message: 'Đã có lỗi xảy ra:\n$e!');
    }
  }

  void _afterUpdate(Map? response, String? newAvatar) {
    if (response != null && response['code'] == 200) {
      if (Get.isRegistered<ProfileController>()) {
        if (newAvatar != null) {
          Get.find<ProfileController>().updateAvatar(newAvatar);
          Utils.saveStringWithKey(Constant.AVATAR, newAvatar);
        }
        Get.find<ProfileController>().updateName(name.text.trim());
      }
      if (Get.isRegistered<HomeController>()) {
        if (newAvatar != null) {
          Get.find<HomeController>().updateAvatar(newAvatar);

          Get.find<HomeController>().updateName(name.text.trim());
        }
        Utils.saveStringWithKey(Constant.NAME, name.text.trim());

        Get.back();
        getDetail();

        Utils.showSnackBar(
          title: 'Thông báo',
          message: response['message'] ?? "Cập nhật thành công",
        );
      } else {
        Utils.showSnackBar(
          title: 'Error',
          message: response['message'] ?? "Cập nhật thất bại",
        );
      }
    }
  }
}
