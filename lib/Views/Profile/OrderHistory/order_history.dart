import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Profile/OrderHistory/order_history_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Models/OrderHistorys.dart';
import 'package:utshop/Routes/app_page.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key});

  final controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        elevation: 0,
        title: const Text(
          "Lịch sử đơn hàng",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (controller.orderList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchOrderHistory,
            color: AppColor.primary,
            child: Stack(
              children: [
                ListView(),
                const Center(
                  child: Text(
                    "Bạn chưa có đơn hàng nào.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOrderHistory,
          color: AppColor.primary,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemCount: controller.orderList.length,
            itemBuilder: (context, index) {
              final order = controller.orderList[index];
              return _buildOrderItem(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderItem(OrderHis order) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.detailOrderHistory, arguments: order.uuid);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                    "Đơn hàng ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "#${order.orderCode ?? 'N/A'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Divider(color: Colors.grey, height: 1),
              SizedBox(height: 16),
              Row(
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
                          (order.mainImageUrl != null &&
                                  order.mainImageUrl!.isNotEmpty)
                              ? Image.network(
                                order.mainImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    ),
                              )
                              : const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Thông tin
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productName ?? 'Sản phẩm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if ((int.tryParse(order.totalItemsCount ?? '0') ?? 0) >
                            1)
                          Text(
                            'và ${(int.tryParse(order.totalItemsCount!) ?? 1) - 1} sản phẩm khác...',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: AppColor.grey,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'Phân loại: ${controller.getVariantText(order)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColor.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Trạng thái: ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.grey,
                              ),
                            ),
                            Text(
                              controller.getStatusText(order.status),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: controller.getStatusColor(order.status),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey, height: 1),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng tiền:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  Text(
                    controller.getFormattedTotal(order.totalAmount),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Obx(() {
                  final isLoading =
                      controller.isBuyingAgain[order.uuid] ?? false;

                  return ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              controller.buyAgain(order.uuid!);
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                            : Text(
                              "Mua lại",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
