import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Components/custom_dialog.dart';
import 'package:utshop/Controllers/Profile/DeliveryAddress/delivery_address_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Models/DeliveryAdress.dart';

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
      body: RefreshIndicator(
        onRefresh: () => controller.fetchAddresses(isRefresh: true),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (controller.addressList.isEmpty) {
            return Stack(
              children: [
                ListView(),
                Center(
                  child: Text(
                    "Bạn chưa có địa chỉ nào.\nHãy thêm một địa chỉ mới.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: controller.addressList.length,
            itemBuilder: (context, index) {
              final address = controller.addressList[index];
              return _buildAddressCard(context, address);
            },
          );
        }),
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
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            controller.clearFormControllers();
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
      ).paddingOnly(bottom: 20),
    );
  }

  Widget _buildAddressCard(BuildContext context, DeliveryAdd address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color:
              address.isDefault == 1
                  ? Colors.green.shade50
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
          border:
              address.isDefault == 1
                  ? Border.all(color: Colors.green, width: 1.5)
                  : null,
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
                    address.isDefault == 1
                        ? "Địa chỉ (Mặc định)"
                        : "Địa chỉ giao hàng",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          address.isDefault == 1 ? Colors.green : Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.fillFormForEdit(address);
                          _editDeliveryAddress(context, address.uuid!); //
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
                            onPressed: () {
                              Get.back();
                              controller.deleteAddress(address.uuid!);
                            },
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
                  _infoRow("Tên người nhận:", address.recipientName ?? ''),
                  SizedBox(height: 8),
                  _infoRow("Số điện thoại:", address.phone ?? ''),
                  SizedBox(height: 8),
                  _infoRow(
                    "Địa chỉ:",
                    "${address.address}, ${address.district}, ${address.province}",
                    isAddress: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isAddress = false}) {
    return Row(
      crossAxisAlignment:
          isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
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
    );
  }

  void _addDeliveryAddress(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _inputField(
                          label: "Tên khách hàng",
                          hint: "Nhập tên khách hàng",
                          icon: Icons.person_outline,
                          controller: controller.recipientNameController,
                        ),
                        _inputField(
                          label: "Số điện thoại",
                          hint: "Nhập số điện thoại",
                          keyboardType: TextInputType.phone,
                          icon: Icons.phone_outlined,
                          controller: controller.phoneController,
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
                          controller: controller.provinceController,
                        ),
                        _inputField(
                          label: "Quận/Huyện",
                          hint: "Nhập Quận/Huyện",
                          icon: Icons.location_on_outlined,
                          controller: controller.districtController,
                        ),
                        _inputField(
                          label: "Địa chỉ chi tiết",
                          hint: "Số nhà, tên đường, phường/xã...",
                          icon: Icons.home_outlined,
                          controller: controller.addressController,
                        ),
                        // [CẬP NHẬT] Switch cho "Đặt làm mặc định"
                        Obx(
                          () => SwitchListTile(
                            title: Text("Đặt làm địa chỉ mặc định"),
                            value: controller.isDefault.value,
                            onChanged: (val) {
                              controller.isDefault.value = val;
                            },
                            activeColor: Colors.green,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                      onPressed: () => controller.addAddress(),
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
  }

  void _editDeliveryAddress(BuildContext context, String addressUuid) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _inputField(
                          label: "Tên khách hàng",
                          hint: "Nhập tên khách hàng",
                          icon: Icons.person_outline,
                          controller: controller.recipientNameController,
                        ),
                        _inputField(
                          label: "Số điện thoại",
                          hint: "Nhập số điện thoại",
                          keyboardType: TextInputType.phone,
                          icon: Icons.phone_outlined,
                          controller: controller.phoneController,
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
                          controller: controller.provinceController,
                        ),
                        _inputField(
                          label: "Quận/Huyện",
                          hint: "Nhập Quận/Huyện",
                          icon: Icons.location_on_outlined,
                          controller: controller.districtController,
                        ),
                        _inputField(
                          label: "Địa chỉ chi tiết",
                          hint: "Số nhà, tên đường, phường/xã...",
                          icon: Icons.home_outlined,
                          controller: controller.addressController,
                        ),
                        Obx(
                          () => SwitchListTile(
                            title: Text("Đặt làm địa chỉ mặc định"),
                            value: controller.isDefault.value,
                            onChanged: (val) {
                              controller.isDefault.value = val;
                            },
                            activeColor: Colors.green,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                      onPressed: () => controller.updateAddress(addressUuid),
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
  }

  Widget _inputField({
    required String label,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextEditingController? controller,
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
            controller: controller,
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
