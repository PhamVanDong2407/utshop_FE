import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Controllers/Profile/Voucher/voucher_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Models/Vouchers.dart';

class Voucher extends StatelessWidget {
  Voucher({super.key});

  final controller = Get.put(VoucherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        elevation: 0,
        title: const Text(
          "Danh sách mã giảm giá",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.voucherList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        return RefreshIndicator(
          color: AppColor.primary, 
          onRefresh: () async {
            await controller.getListVouchers(isRefresh: true);
          },
          child: Stack(
            children: [
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: controller.voucherList.length,
                itemBuilder: (context, index) {
                  final voucher = controller.voucherList[index];
                  return VoucherCard(voucher: voucher, controller: controller);
                },
              ),
              if (controller.voucherList.isEmpty && !controller.isLoading.value)
                const Center(child: Text("Bạn không có mã giảm giá nào")),
            ],
          ),
        );
      }),
    );
  }
}

class VoucherCard extends StatelessWidget {
  final ListVouchers voucher;
  final VoucherController controller;

  const VoucherCard({
    super.key,
    required this.voucher,
    required this.controller,
  });

  Widget _buildStatus(String? status) {
    Color color = Colors.green;
    String text = "Còn hiệu lực";

    switch (status) {
      case "expired":
        color = Colors.red;
        text = "Hết hạn";
        break;
      case "used":
        color = Colors.grey.shade700;
        text = "Đã dùng";
        break;
      case "depleted":
        color = Colors.orange.shade700;
        text = "Hết lượt";
        break;
      case "upcoming":
        color = Colors.blue.shade700;
        text = "Sắp diễn ra";
        break;
    }

    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
    );
  }

  String _formatDiscount(int? type, String? value) {
    final parsedValue = double.tryParse(value ?? "0") ?? 0.0;
    if (type == 0) {
      return "-${parsedValue.toStringAsFixed(0)}%";
    } else {
      return "-${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(parsedValue)}";
    }
  }

  String _formatCurrency(String? value) {
    if (value == null) return "Không giới hạn";
    final parsedValue = double.tryParse(value) ?? 0.0;
    if (parsedValue == 0) return "Không giới hạn";
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    ).format(parsedValue);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          child: Obx(() {
            final bool isThisCardExpanded = controller.expandedVoucherUuids
                .contains(voucher.uuid);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "CODE: ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          voucher.code ?? "N/A",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                    _buildStatus(voucher.status),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(height: 1, color: AppColor.grey),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Giảm: ",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                    Text(
                      _formatDiscount(
                        voucher.discountType,
                        voucher.discountValue,
                      ),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    if (voucher.discountType == 0) ...[
                      const SizedBox(width: 10),
                      Text("|", style: TextStyle(color: AppColor.grey)),
                      const SizedBox(width: 10),
                      const Text(
                        "Tối đa: ",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      Text(
                        _formatCurrency(voucher.maxDiscountAmount),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
                if (isThisCardExpanded) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Đơn hàng tối thiểu: ",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      Text(
                        _formatCurrency(voucher.minOrderValue),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        "Đã dùng (tổng): ",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      Text(
                        "${voucher.currentUsageCount ?? 0}",
                        style: TextStyle(fontSize: 13, color: AppColor.red),
                      ),
                      Text(
                        "/${(voucher.usageLimitPerVoucher ?? 0) == 0 ? '∞' : voucher.usageLimitPerVoucher}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    voucher.description ?? "Không có mô tả.",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        "Thời gian sử dụng: ",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      Text(
                        "${_formatDate(voucher.startDate)} - ${_formatDate(voucher.endDate)}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        () => controller.toggleExpand(voucher.uuid ?? ''),
                    child: Text(
                      isThisCardExpanded ? "Thu gọn ▲" : "Xem thêm ▼",
                      style: TextStyle(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
