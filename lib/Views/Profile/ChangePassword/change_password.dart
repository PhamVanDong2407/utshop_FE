import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Profile/ChangePassword/change_password_controller.dart';
import 'package:utshop/Global/app_color.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final controller = Get.put(ChangePasswordController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Đổi mật khẩu",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _labelForm(label: "Mật khẩu cũ", isRequired: true),
                        const SizedBox(height: 8),
                        Obx(
                          () => TextFormField(
                            controller: controller.oldPasswordController,
                            obscureText: controller.obscureOldPassword.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              hintText: 'Nhập mật khẩu cũ',
                              hintStyle: TextStyle(color: AppColor.grey),
                              errorStyle: TextStyle(color: AppColor.red),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscureOldPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColor.grey,
                                ),
                                onPressed: () {
                                  controller.obscureOldPassword.value =
                                      !controller.obscureOldPassword.value;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu cũ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _labelForm(label: "Mật khẩu mới", isRequired: true),
                        const SizedBox(height: 8),
                        Obx(
                          () => TextFormField(
                            controller: controller.newPasswordController,
                            obscureText: controller.obscureNewPassword.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              hintText: 'Nhập mật khẩu mới',
                              hintStyle: TextStyle(color: AppColor.grey),
                              errorStyle: TextStyle(color: AppColor.red),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscureNewPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColor.grey,
                                ),
                                onPressed: () {
                                  controller.obscureNewPassword.value =
                                      !controller.obscureNewPassword.value;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu mới';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _labelForm(
                          label: "Xác nhận mật khẩu mới",
                          isRequired: true,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => TextFormField(
                            controller: controller.confirmPasswordController,
                            obscureText:
                                controller.obscureConfirmPassword.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              hintText: 'Xác nhận mật khẩu mới',
                              hintStyle: TextStyle(color: AppColor.grey),
                              errorStyle: TextStyle(color: AppColor.red),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscureConfirmPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColor.grey,
                                ),
                                onPressed: () {
                                  controller.obscureConfirmPassword.value =
                                      !controller.obscureConfirmPassword.value;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập xác nhận mật khẩu mới';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              }
                              if (value !=
                                  controller.newPasswordController.text) {
                                return 'Mật khẩu mới và xác nhận mật khẩu không khớp';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                controller.changePassword();
                              }
                            },
                    child: const Text(
                      'Đổi mật khẩu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Row _labelForm({required String label, bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.text1,
          ),
        ),
        const SizedBox(width: 4),
        if (isRequired)
          Text(
            "*",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.red,
            ),
          ),
      ],
    );
  }
}
