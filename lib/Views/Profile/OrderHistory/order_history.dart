import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Profile/OrderHistory/order_history_controller.dart';
import 'package:utshop/Global/app_color.dart';

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
      body: ListView(
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
                    color: Colors.black.withOpacity(0.05),
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
                          "#1",
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
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                            // Thêm Image.network hoặc Asset để hiển thị ảnh thật
                            // image: DecorationImage(
                            //   image: NetworkImage('URL_HINH_ANH_SAN_PHAM'),
                            //   fit: BoxFit.cover,
                            // ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: const Offset(0, -2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),

                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tên Sản Phẩm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '1',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.grey,
                                  ),
                                ),
                                Text(
                                  ' sản phẩm',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Phân loại:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.grey,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Đỏ/XL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
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
                                  'Đang xử lý',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                          "500.000 ₫",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
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
    );
  }
}
