import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Models/user.dart';
import 'package:utshop/Services/api_caller.dart';

class InfoController extends GetxController {
  RxBool isWaitSubmit = false.obs;
  Rx<File> avatarLocal = Rx<File>(File(''));
  RxString avatar = ''.obs;
  RxInt gender = 0.obs; // 0: Nam, 1: Nữ
  User detail = User();

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthDay = TextEditingController();

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
      debugPrint(e.toString());
      isWaitSubmit.value = false;
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
    birthDay.text = detail.birthDay ?? '';
    gender.value = (detail.gender == "1") ? 1 : 0;
  }
}
