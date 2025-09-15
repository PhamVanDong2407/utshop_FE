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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phạm Văn Đông',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'dongkeyphe@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
