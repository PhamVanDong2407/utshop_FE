import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/Cart/cart_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Models/Carts.dart'; // Import model
import 'package:utshop/Routes/app_page.dart';

class Cart extends StatelessWidget {
  Cart({super.key});

  final controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx(() {
        // --- 1. TRẠNG THÁI TẢI ---
        if (controller.isLoading.value && controller.cart.value == null) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        // --- 2. TRẠNG THÁI RỖNG ---
        if (controller.cart.value == null ||
            controller.cart.value!.items == null ||
            controller.cart.value!.items!.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.getListCart,
            color: AppColor.primary,
            child: Stack(
              children: [
                ListView(),
                const Center(
                  child: Text(
                    "Giỏ hàng của bạn đang trống",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        // --- 3. TRẠNG THÁI CÓ DỮ LIỆU ---
        var cart = controller.cart.value!;
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.getListCart,
                color: AppColor.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: cart.items!.length,
                  itemBuilder: (context, index) {
                    final item = cart.items![index];
                    return Obx(() => _buildCartItem(context, controller, item));
                  },
                ),
              ),
            ),
            // Thanh toán
            _buildCheckoutBar(context, controller, cart),
            const SizedBox(height: 70), // Khoảng trống cho Bottom Nav
          ],
        );
      }),
    );
  }

  /// Widget cho từng sản phẩm trong giỏ
  Widget _buildCartItem(
    BuildContext context,
    CartController controller,
    Items item,
  ) {
    return Row(
      children: [
        // --- CHECKBOX CHO TỪNG ITEM ---
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColor.primary.withAlpha(110),
          ),
          child: Checkbox(
            value: controller.isItemSelected(item.variantUuid!),
            onChanged: (val) {
              controller.toggleItemSelection(item.variantUuid!);
            },
            activeColor: AppColor.primary,
          ),
        ),
        // --- ITEM CARD ---
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HÌNH ẢNH ---
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              item.mainImageUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // --- THÔNG TIN SẢN PHẨM ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName ?? 'Sản phẩm',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.getVariantText(item),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                // SỬA: Hiển thị subtotal (giá * sl)
                                controller.formatCurrency(item.subtotal),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // --- NÚT XÓA ---
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 24,
                            ),
                            onPressed:
                                () => controller.showDeleteConfirmation(item),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey, thickness: 1),
                    // --- HÀNG SỐ LƯỢNG ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Số lượng",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            _quantityButton(
                              icon: Icons.remove,
                              // === SỬA LẠI HÀM ===
                              onTap: () => controller.decrementQuantity(item),
                              isEnabled: item.quantity! > 1,
                            ),
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            _quantityButton(
                              icon: Icons.add,
                              onTap: () => controller.incrementQuantity(item),
                              isEnabled: true, // Controller sẽ check stock
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
        ),
      ],
    );
  }

  /// Widget thanh toán
  Widget _buildCheckoutBar(
    BuildContext context,
    CartController controller,
    UserCart cart,
  ) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              offset: const Offset(0, -4),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HÀNG CHỌN TẤT CẢ ---
            Row(
              children: [
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: AppColor.primary.withAlpha(110),
                  ),
                  child: Checkbox(
                    value: controller.isAllSelected,
                    onChanged: (val) {
                      controller.toggleSelectAll();
                    },
                    activeColor: AppColor.primary,
                  ),
                ),
                Text(
                  "Chọn tất cả (${cart.items?.length ?? 0} sản phẩm)",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // --- HÀNG TỔNG TIỀN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng ( ${controller.selectedItemCount} sản phẩm ): ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  controller.formatCurrency(controller.selectedTotalAmount),
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // --- NÚT THANH TOÁN ---
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    controller.selectedItemCount == 0
                        ? null
                        : () {
                          // Lấy danh sách item đã CHỌN (với SỐ LƯỢNG MỚI)
                          List<Items> itemsToCheckout =
                              controller.selectedCartItems;

                          // Truyền danh sách này sang màn hình mới
                          Get.toNamed(
                            Routes.confirmOrder,
                            arguments: itemsToCheckout,
                          );
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  disabledBackgroundColor: Colors.grey,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.payment, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Tiến hành thanh toán',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Nút Tăng/Giảm số lượng
  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    Color buttonColor = isEnabled ? AppColor.primary : Colors.grey.shade400;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.grey.shade200,
          shape: BoxShape.circle,
          border: Border.all(color: buttonColor, width: 1.5),
        ),
        child: Icon(icon, size: 20, color: buttonColor),
      ),
    );
  }
}
