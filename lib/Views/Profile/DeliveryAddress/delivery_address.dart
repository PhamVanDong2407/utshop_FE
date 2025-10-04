import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Components/custom_dialog.dart';
import 'package:utshop/Controllers/Profile/DeliveryAddress/delivery_address_controller.dart';
import 'package:utshop/Global/app_color.dart';

class DeliveryAddress extends StatelessWidget {
  DeliveryAddress({super.key});

  final controller = Get.put(DeliveryAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        elevation: 0,
        title: const Text(
          "Danh sách địa chỉ giao hàng",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Địa chỉ giao hàng",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _editDeliveryAddress(context);
                                  },
                                  icon: Icon(
                                    Icons.edit_location_alt_outlined,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    CustomDialog.show(
                                      context: context,
                                      color: Colors.red,
                                      title: "Xóa địa chỉ",
                                      content:
                                          "Bạn có chắc muốn xóa địa chỉ giao hàng này không?",
                                      onPressed: () {},
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(color: Colors.grey, height: 1),
                        SizedBox(height: 16),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("Tên khách hàng:"),
                                Spacer(),
                                Text(
                                  "Phạm Văn Đông",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text("Số điện thoại"),
                                Spacer(),
                                Text(
                                  "0999999999",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Địa chỉ:"),
                                Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Khu 3, Xã Thạch Bình, Tỉnh Thanh Hóa",
                                    textAlign: TextAlign.right,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              _addDeliveryAddress(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Thêm địa chỉ giao hàng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addDeliveryAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Thêm địa chỉ giao hàng",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.text1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _inputField(
                      label: "Tên khách hàng",
                      hint: "Nhập tên khách hàng",
                      icon: Icons.person_outline,
                    ),
                    _inputField(
                      label: "Số điện thoại",
                      hint: "Nhập số điện thoại",
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Địa chỉ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColor.text1,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _inputField(
                      label: "Tỉnh/Thành phố",
                      hint: "Nhập Tỉnh/Thành phố",
                      icon: Icons.location_city_outlined,
                    ),
                    _inputField(
                      label: "Xã/Thị trấn",
                      hint: "Nhập Xã/Thị trấn",
                      icon: Icons.location_on_outlined,
                    ),
                    _inputField(
                      label: "Địa chỉ chi tiết",
                      hint: "Nhập địa chỉ chi tiết",
                      icon: Icons.home_outlined,
                    ),
                    const SizedBox(height: 28),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Lưu địa chỉ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editDeliveryAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Chỉnh sửa địa chỉ giao hàng",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.text1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _inputField(
                      label: "Tên khách hàng",
                      hint: "Nhập tên khách hàng",
                      icon: Icons.person_outline,
                    ),
                    _inputField(
                      label: "Số điện thoại",
                      hint: "Nhập số điện thoại",
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Địa chỉ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColor.text1,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _inputField(
                      label: "Tỉnh/Thành phố",
                      hint: "Nhập Tỉnh/Thành phố",
                      icon: Icons.location_city_outlined,
                    ),
                    _inputField(
                      label: "Xã/Thị trấn",
                      hint: "Nhập Xã/Thị trấn",
                      icon: Icons.location_on_outlined,
                    ),
                    _inputField(
                      label: "Địa chỉ chi tiết",
                      hint: "Nhập địa chỉ chi tiết",
                      icon: Icons.home_outlined,
                    ),
                    const SizedBox(height: 28),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cập nhật địa chỉ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _inputField({
    required String label,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon:
                  icon != null ? Icon(icon, color: Colors.grey[600]) : null,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
