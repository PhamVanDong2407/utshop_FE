import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Components/custom_dialog.dart';
import 'package:utshop/Controllers/Profile/profile_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Services/auth.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Obx(
                    () => ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                          controller.avatar.value.isNotEmpty
                              ? Image.network(
                                controller.baseUrl + controller.avatar.value,
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.person,
                                      size: 35,
                                      color: Colors.black,
                                    ),
                              )
                              : const Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.black,
                              ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            controller.name.value == ''
                                ? 'Người dùng'
                                : controller.name.value,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            controller.email.value == ''
                                ? 'Chưa cập nhật email'
                                : controller.email.value,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  title: 'Thông tin cá nhân',
                  icon: Icons.person,
                  onTap: () {
                    Get.toNamed(Routes.info);
                  },
                ),
                _buildMenuItem(
                  title: 'Lịch sử đơn hàng',
                  icon: Icons.history,
                  onTap: () {
                    Get.toNamed(Routes.orderHistory);
                  },
                ),
                _buildMenuItem(
                  title: 'Địa chỉ giao hàng',
                  icon: Icons.location_on,
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Kho Voucher',
                  icon: Icons.card_giftcard,
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Đổi mật khẩu',
                  icon: Icons.lock,
                  onTap: () {
                    Get.toNamed(Routes.changePassword);
                  },
                ),
                _buildMenuItem(
                  title: 'Đăng xuất',
                  icon: Icons.logout,
                  showDivider: false,
                  onTap: () {
                    CustomDialog.show(
                      context: context,
                      title: "Đăng xuất",
                      content:
                          "Bạn có chắc muốn đăng xuất khỏi ứng dụng không?",
                      onPressed: () => Auth.backLogin(true),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColor.primary, size: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey[300],
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
