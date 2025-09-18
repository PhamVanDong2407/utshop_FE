import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Profile/Info/Info_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Utils/utils.dart';

class Info extends StatelessWidget {
  Info({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        elevation: 0,
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _buildAvatar(),
                const SizedBox(height: 16),
                _sectionTitle("Thông tin cá nhân"),
                _inputField(
                  label: "Họ và tên",
                  hint: "Nhập họ và tên",
                  controller: controller.name,
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? "Vui lòng nhập họ và tên"
                              : null,
                ),
                _inputField(
                  label: "Số điện thoại",
                  hint: "Nhập số điện thoại",
                  controller: controller.phone,
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? "Vui lòng nhập số điện thoại"
                              : null,
                  keyboardType: TextInputType.phone,
                ),
                _inputField(
                  label: "Email",
                  hint: "Nhập email",
                  controller: controller.email,
                  validator: (v) {
                    if (v != null && v.isNotEmpty) {
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(v)) {
                        return "Vui lòng nhập email hợp lệ";
                      }
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                _dateField(context, controller.birthDay),
                _genderSelector(),

                _sectionTitle("Địa chỉ"),
                _inputField(
                  label: "Tỉnh/Thành phố",
                  hint: "Nhập Tỉnh/Thành phố",
                  controller: controller.province,
                ),
                _inputField(
                  label: "Xã/Thị trấn",
                  hint: "Nhập Xã/Thị trấn",
                  controller: controller.district,
                ),
                _inputField(
                  label: "Địa chỉ chi tiết",
                  hint: "Nhập địa chỉ chi tiết",
                  controller: controller.address,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Nút cập nhật
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cập nhật hồ sơ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Utils.getImagePicker(2).then((value) {
            if (value != null) {
              controller.avatarLocal.value = value;
            }
          });
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Obx(
                () =>
                    controller.avatarLocal.value.path != ""
                        ? Image.file(
                          controller.avatarLocal.value,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                        : Image.network(
                          "${Constant.BASE_URL_IMAGE}${controller.avatar.value}",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stack) => CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColor.primary,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColor.white,
                                ),
                              ),
                        ),
              ),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColor.primary,
              child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _dateField(BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "Ngày sinh",
          hintText: "dd/mm/yyyy",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.blue),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller.text =
                    "${picked.day}/${picked.month}/${picked.year}";
              }
            },
          ),
        ),
        keyboardType: TextInputType.datetime,
      ),
    );
  }

  Widget _genderSelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const Text("Chọn giới tính", style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: RadioListTile<int>(
                      title: const Text('Nam'),
                      value: 0,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.gender.value = value;
                        }
                      },
                      activeColor: AppColor.primary,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      title: const Text('Nữ'),
                      value: 1,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.gender.value = value;
                        }
                      },
                      activeColor: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.text1,
        ),
      ),
    );
  }
}
