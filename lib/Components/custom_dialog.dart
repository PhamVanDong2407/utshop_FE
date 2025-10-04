import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Utils/device_helper.dart';

class CustomDialog {
  static void show({
    required BuildContext context,
    required String title,
    required Color color,
    required String content,
    required void Function() onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.main,
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: DeviceHelper.getFontSize(20),
                  color: AppColor.text1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: TextStyle(
                  fontSize: DeviceHelper.getFontSize(14),
                  color: AppColor.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.boder,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Hủy bỏ",
                        style: TextStyle(
                          fontSize: DeviceHelper.getFontSize(14),
                          color: AppColor.text1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        onPressed();
                      },
                      child: Text(
                        "Xác nhận",
                        style: TextStyle(
                          fontSize: DeviceHelper.getFontSize(14),
                          color: AppColor.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void dialogEmpty({
    required BuildContext context,
    required Widget body,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.main,
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: body,
        );
      },
    );
  }
}
