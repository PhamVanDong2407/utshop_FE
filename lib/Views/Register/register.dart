import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Register/register_controller.dart';
import 'package:utshop/Global/app_color.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: AppColor.primary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: AppColor.primary.withAlpha(5)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary.withAlpha(3)),
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
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hãy điền thông tin để bắt đầu',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 32),

              /// Họ và tên
              _buildTextField(
                controller: controller.fullName,
                label: 'Họ và tên',
                hint: 'Nhập họ và tên',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Vui lòng nhập họ và tên'
                            : null,
              ),
              const SizedBox(height: 20),

              /// Email
              _buildTextField(
                controller: controller.email,
                label: 'Email',
                hint: 'Nhập email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) return 'Email không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Mật khẩu
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              /// Xác nhận mật khẩu
              _buildTextField(
                controller: controller.confirmPassword,
                label: 'Xác nhận mật khẩu',
                hint: 'Nhập lại mật khẩu',
                obscureText: true,
                validator:
                    (value) =>
                        value != controller.password.text
                            ? 'Mật khẩu không khớp'
                            : null,
              ),
              const SizedBox(height: 20),

              /// Số điện thoại
              _buildTextField(
                controller: controller.phone,
                label: 'Số điện thoại',
                hint: 'Nhập số điện thoại',
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Vui lòng nhập số điện thoại'
                            : null,
              ),
              const SizedBox(height: 24),

              /// Checkbox điều khoản
              Obx(
                () => CheckboxListTile(
                  value: controller.agreed.value,
                  onChanged:
                      (value) => controller.agreed.value = value ?? false,
                  title: Text(
                    'Tôi đồng ý với các điều khoản và chính sách',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  activeColor: AppColor.primary,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              /// Nút tạo tài khoản
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!controller.agreed.value) {
                        Get.snackbar(
                          'Lỗi',
                          'Bạn phải đồng ý điều khoản',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      controller.register();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: AppColor.primary.withAlpha(4),
                  ),
                  child: const Text(
                    'Tạo tài khoản',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColor.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Hoặc',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColor.black),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// Đăng nhập bằng Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.loginWithGoogle(),
                  icon: SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 24,
                    height: 24,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      'Đăng nhập bằng Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFDD4B39),
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFDD4B39), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
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
            color: AppColor.primary.withAlpha(50),
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
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
