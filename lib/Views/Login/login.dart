import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Login/login_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Utils/device_helper.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: AppColor.primary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: AppColor.primary.withOpacity(0.5)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chào mừng trở lại',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đăng nhập để tiếp tục mua sắm và nhận ưu đãi độc quyền',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: controller.usermame,
                      label: 'Email',
                      hint: 'Nhập email',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Email không được để trống!'
                                  : null,
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => _buildTextField(
                        controller: controller.password,
                        label: 'Mật khẩu',
                        hint: 'Nhập mật khẩu',
                        obscureText: controller.isPasswordHidden.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColor.primary,
                          ),
                          onPressed: () => controller.isPasswordHidden.toggle(),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Mật khẩu không được để trống!'
                                    : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.forgotPassword);
                        },
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: DeviceHelper.getFontSize(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.submit();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: AppColor.primary.withOpacity(0.4),
                            ),
                            child: Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: DeviceHelper.getFontSize(16),
                                fontWeight: FontWeight.w600,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Get.toNamed(Routes.register),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: AppColor.primary,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Tạo tài khoản',
                              style: TextStyle(
                                fontSize: DeviceHelper.getFontSize(16),
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColor.black.withOpacity(0.2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Hoặc',
                                style: TextStyle(
                                  fontSize: DeviceHelper.getFontSize(16),
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColor.black.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: Color(0xFFDD4B39),
                                width: 2,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/icons/google.svg',
                              width: 24,
                              height: 24,
                            ),
                            label: Text(
                              'Đăng nhập bằng Google',
                              style: TextStyle(
                                fontSize: DeviceHelper.getFontSize(16),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFDD4B39),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: _inputDecoration(
          label,
          hint,
        ).copyWith(suffixIcon: suffixIcon),
        validator: validator,
        style: TextStyle(
          fontSize: DeviceHelper.getFontSize(16),
          fontWeight: FontWeight.w500,
          color: AppColor.text1,
        ),
      ),
    );
  }
}
