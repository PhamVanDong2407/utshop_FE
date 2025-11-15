import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Profile/OrderHistory/DetailOrderHistory/detail_order_history_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Models/DetailOrderHistorys.dart';

class DetailOrderHistory extends StatelessWidget {
  DetailOrderHistory({super.key});

  final controller = Get.put(DetailOrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        elevation: 0,
        title: const Text(
          "Chi tiết đơn hàng",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }
        if (controller.orderDetail.value == null) {
          return Center(
            child: Text(
              "Không thể tải chi tiết đơn hàng.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final order = controller.orderDetail.value!;
        final fullAddress = [
          order.address,
          order.district,
          order.province,
        ].where((s) => s != null && s.isNotEmpty).join(', ');

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildInfoCard(
                title: "Thông tin đơn hàng",
                children: [
                  _buildInfoRow("Mã đơn hàng:", "#${order.orderCode ?? 'N/A'}"),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Ngày đặt hàng:"),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            controller.getFormattedDate(order.createdAt),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            controller.getFormattedTime(order.createdAt),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    "Trạng thái:",
                    controller.getStatusText(order.status),
                    valueColor: controller.getStatusColor(order.status),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    "Phương thức thanh toán:",
                    order.paymentMethod?.toUpperCase() ?? 'N/A',
                  ),
                ],
              ),

              SizedBox(height: 16),

              _buildInfoCard(
                title: "Địa chỉ giao hàng",
                children: [
                  _buildInfoRow(
                    "Tên khách hàng:",
                    order.recipientName ?? 'N/A',
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow("Số điện thoại", order.phone ?? 'N/A'),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    "Địa chỉ:",
                    fullAddress.isNotEmpty ? fullAddress : 'N/A',
                    isAddress: true,
                  ),
                ],
              ),

              SizedBox(height: 16),

              _buildInfoCard(
                title: "Danh sách sản phẩm",
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order.items?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = order.items![index];
                      return _buildOrderItem(item);
                    },
                  ),
                ],
              ),

              SizedBox(height: 16),

              _buildInfoCard(
                title: "Chi tiết thanh toán",
                children: [
                  _buildInfoRow(
                    "Tổng tiền hàng:",
                    controller.formatCurrency(order.subtotal),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    "Phí vận chuyển:",
                    controller.formatCurrency(order.shippingFee),
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Giảm giá"),
                          SizedBox(width: 4),
                          Text(
                            "(${order.voucherCode ?? 'Không có'}):",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        "-${controller.formatCurrency(order.discount)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
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
                        controller.formatCurrency(order.totalAmount),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 40),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.red,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'Hủy đơn hàng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ).paddingOnly(bottom: 20),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
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
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Divider(color: Colors.grey, height: 1),
              SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isAddress = false,
  }) {
    return Row(
      crossAxisAlignment:
          isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text("$label:"),
        Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: isAddress ? 15 : 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(Items item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:
                  (item.mainImageUrl != null && item.mainImageUrl!.isNotEmpty)
                      ? Image.network(
                        item.mainImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.image, color: Colors.grey),
                      )
                      : const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),
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
                const SizedBox(height: 4),
                Text(
                  'Số lượng: ${item.quantity ?? 0}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phân loại: ${controller.getVariantText(item)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Giá: ${controller.formatCurrency(item.price)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
