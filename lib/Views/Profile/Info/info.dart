import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Profile/Info/Info_controller.dart';
import 'package:utshop/Global/app_color.dart';

class Info extends StatelessWidget {
  Info({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Thông tin cá nhân",
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
                        Text(
                          "Thông tin cá nhân của bạn",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _labelForm(label: "Họ và tên", isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            hintText: "Nhập họ và tên",
                            hintStyle: TextStyle(color: AppColor.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập họ và tên';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _labelForm(label: "Số điện thoại", isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            hintText: "Nhập số điện thoại",
                            hintStyle: TextStyle(color: AppColor.black),
                          ),
                          validator:
                              (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Vui lòng nhập số điện thoại'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        _labelForm(label: "Email", isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            hintText: "Nhập email",
                            hintStyle: TextStyle(color: AppColor.black),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Vui lòng nhập email hợp lệ';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _labelForm(label: "Ngày sinh"),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            hintText: "dd/mm/yyyy",
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.blue,
                                size: 24,
                              ),
                              tooltip: 'Chọn ngày sinh',
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                              },
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                        Row(
                          children: [
                            _labelForm(label: "Chọn giới tính"),
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

                        Text(
                          "Địa chỉ",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),

                        ),
                      ],
                    ),
                  ),
                ],
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
