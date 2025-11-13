import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Controllers/Cart/ConfirmOrder/confirm_order_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Models/DeliveryAdress.dart';
import 'package:utshop/Models/Carts.dart';

class ConfirmOrder extends StatelessWidget {
  ConfirmOrder({super.key});

  final controller = Get.put(ConfirmOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        elevation: 0,
        title: const Text(
          "Xác nhận đơn hàng",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                        children: [
                          Text(
                            "Giao hàng đến",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              _editDeliveryAddress(context);
                            },
                            icon: Icon(
                              Icons.edit_location_alt_outlined,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey, height: 1),
                      SizedBox(height: 16),
                      Obx(() {
                        if (controller.isLoading.value &&
                            controller.selectedAddress.value == null) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColor.primary,
                              ),
                            ),
                          );
                        }
                        final address = controller.selectedAddress.value;
                        if (address == null) {
                          return Center(
                            child: Text(
                              "Vui lòng thêm địa chỉ giao hàng",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          );
                        }
                        final fullAddress = [
                          address.address,
                          address.district,
                          address.province,
                        ].where((s) => s != null && s.isNotEmpty).join(', ');
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text("Tên người nhận:"),
                                Spacer(),
                                Text(
                                  address.recipientName ?? "--",
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
                                Text("Số điện thoại:"),
                                Spacer(),
                                Text(
                                  address.phone ?? "--",
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
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    fullAddress.isNotEmpty ? fullAddress : "--",
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
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          // Bọc Obx để cập nhật số lượng
                          "Tóm tắt đơn hàng (${controller.itemsToCheckout.length} sản phẩm)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey, height: 1),
                      SizedBox(height: 8),
                      Obx(
                        () => ListView.builder(
                          itemCount: controller.itemsToCheckout.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = controller.itemsToCheckout[index];
                            return _buildOrderItem(item);
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mã giảm giá",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey, height: 1),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return CouponListBottomSheet(
                                controller: controller,
                              );
                            },
                          );
                        },
                        child: AbsorbPointer(
                          child: Obx(() {
                            final selectedCode =
                                controller.selectedVoucher.value?.code;
                            return TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: "Chọn mã giảm giá",
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                              controller: TextEditingController(
                                text: selectedCode ?? "Chọn mã giảm giá",
                              ),
                              style: TextStyle(
                                color:
                                    selectedCode != null
                                        ? Colors.green
                                        : Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

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
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chi tiết thanh toán",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(color: Colors.grey, height: 1),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Tổng tiền hàng:",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              controller.formatCurrency(
                                controller.subtotalAmount.value,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "Phí giao hàng:",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              controller.formatCurrency(
                                controller.shippingFee.value,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "Giảm giá voucher: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "-${controller.formatCurrency(controller.voucherDiscount.value)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(color: Colors.grey, height: 1),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Tổng thanh toán:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              controller.formatCurrency(
                                controller.totalAmount.value,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
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

            SizedBox(height: 16),

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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Phương thức thanh toán",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.grey, height: 1),
                      const SizedBox(height: 8),
                      Obx(
                        () => Column(
                          children: [
                            RadioListTile<PaymentMethod>(
                              title: const Text(
                                'Thanh toán khi nhận hàng',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              secondary: Icon(
                                Icons.local_shipping_outlined,
                                color:
                                    controller.selectedPaymentMethod.value ==
                                            PaymentMethod.cod
                                        ? AppColor.primary
                                        : Colors.grey,
                              ),
                              value: PaymentMethod.cod,
                              groupValue:
                                  controller.selectedPaymentMethod.value,
                              onChanged: (PaymentMethod? value) {
                                controller.selectPaymentMethod(value);
                              },
                              contentPadding: EdgeInsets.zero,
                              activeColor: AppColor.primary,
                            ),
                            RadioListTile<PaymentMethod>(
                              title: const Text(
                                'Chuyển khoản bằng mã VietQR',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              secondary: Icon(
                                Icons.qr_code_2_rounded,
                                color:
                                    controller.selectedPaymentMethod.value ==
                                            PaymentMethod.vietqr
                                        ? AppColor.primary
                                        : Colors.grey,
                              ),
                              value: PaymentMethod.vietqr,
                              groupValue:
                                  controller.selectedPaymentMethod.value,
                              onChanged: (PaymentMethod? value) {
                                controller.selectPaymentMethod(value);
                              },
                              contentPadding: EdgeInsets.zero,
                              activeColor: AppColor.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: 40),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tổng thanh toán:",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      controller.formatCurrency(controller.totalAmount.value),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Đặt hàng ngay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).paddingOnly(bottom: 5),
    );
  }

  Widget _buildOrderItem(Items item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.mainImageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Thông tin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Sản phẩm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  controller.getVariantText(item),
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SL: ${item.quantity}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      controller.formatCurrency(item.subtotal),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editDeliveryAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Container(
          height: screenHeight * 0.75,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
                    "Chọn địa chỉ giao hàng",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.text1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300], height: 1),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.addressList.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primary,
                        ),
                      );
                    }
                    if (controller.addressList.isEmpty) {
                      return Center(child: Text("Bạn chưa có địa chỉ nào."));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: controller.addressList.length,
                      itemBuilder: (context, index) {
                        final address = controller.addressList[index];
                        final isSelected =
                            controller.selectedAddress.value?.uuid ==
                            address.uuid;
                        return _buildAddressItem(context, address, isSelected);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressItem(
    BuildContext context,
    DeliveryAdd address,
    bool isSelected,
  ) {
    final fullAddress = [
      address.address,
      address.district,
      address.province,
    ].where((s) => s != null && s.isNotEmpty).join(', ');

    return InkWell(
      onTap: () {
        controller.selectAddress(address);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColor.primary.withAlpha(5) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColor.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.recipientName ?? "N/A",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "  |  ",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        address.phone ?? "N/A",
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fullAddress.isNotEmpty ? fullAddress : "Chưa có địa chỉ",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    softWrap: true,
                  ),
                  if (address.isDefault == 1)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Mặc định",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
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
}

class CouponListBottomSheet extends StatelessWidget {
  final ConfirmOrderController controller;
  const CouponListBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Helper format tiền
    String formatCurrency(String? value) {
      if (value == null || value.isEmpty) return "0 ₫";
      try {
        final double number = double.parse(value);
        final format = NumberFormat.currency(
          locale: 'vi_VN',
          symbol: '₫',
          decimalDigits: 0,
        );
        return format.format(number);
      } catch (e) {
        return value;
      }
    }

    // Helper format ngày
    String formatDate(String? dateString) {
      if (dateString == null) return "N/A";
      try {
        final DateTime date = DateTime.parse(dateString);
        return DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        return dateString;
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chọn Mã Giảm Giá",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300], height: 1),
          Expanded(
            child: Obx(() {
              if (controller.voucherList.isEmpty) {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  );
                }
                return Center(
                  child: Text(
                    "Bạn không có mã giảm giá nào",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                itemCount: controller.voucherList.length,
                itemBuilder: (context, index) {
                  final voucher = controller.voucherList[index];
                  String title = voucher.description ?? "Giảm giá";
                  String description =
                      "Đơn tối thiểu ${formatCurrency(voucher.minOrderValue)}";

                  if (voucher.maxDiscountAmount != null &&
                      voucher.maxDiscountAmount != "0") {
                    description +=
                        ". Giảm tối đa ${formatCurrency(voucher.maxDiscountAmount)}";
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CouponItem(
                      code: voucher.code ?? "N/A",
                      title: title,
                      description: description,
                      expiryDate: "HSD: ${formatDate(voucher.endDate)}",
                      onApply: () {
                        controller.selectVoucher(voucher);
                        Navigator.pop(context);
                      },
                    ),
                  ).paddingOnly(
                    bottom: index == controller.voucherList.length - 1 ? 20 : 0,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CouponItem extends StatelessWidget {
  final String code;
  final String title;
  final String description;
  final String expiryDate;
  final VoidCallback onApply;

  const CouponItem({
    super.key,
    required this.code,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.green.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withAlpha(15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.discount, color: Colors.green, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  expiryDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size(60, 30),
              ),
              child: const Text("Chọn", style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
