import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Profile/ChangePassword/change_password_controller.dart';
import 'package:utshop/Global/app_color.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ChangePasswordController());

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
                        TextFormField(
                          obscureText: controller.obscureOldPassword,
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
                                controller.obscureOldPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColor.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  controller.obscureOldPassword =
                                      !controller.obscureOldPassword;
                                });
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
                        const SizedBox(height: 16),
                        _labelForm(label: "Mật khẩu mới", isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: controller.obscureNewPassword,
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
                                controller.obscureNewPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColor.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  controller.obscureNewPassword =
                                      !controller.obscureNewPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu mới';
                            }
                            if (value.length < 6) {
                              return ' Mật khẩu phải có ít nhất 6 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _labelForm(
                          label: "Xác nhận mật khẩu mới",
                          isRequired: true,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: controller.obscureConfirmPassword,
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
                                controller.obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColor.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  controller.obscureConfirmPassword =
                                      !controller.obscureConfirmPassword;
                                });
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
                            return null;
                          },
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Xử lý đổi mật khẩu
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
