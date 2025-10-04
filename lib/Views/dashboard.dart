import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:utshop/Components/custom_dialog.dart';
import 'package:utshop/Controllers/dashboard_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Views/Cart/cart.dart';
import 'package:utshop/Views/Home/home.dart';
import 'package:utshop/Views/Profile/profile.dart';
import 'package:utshop/Views/Wishlist/wishlish.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final controller = Get.put(DashboardController());

  final List<Widget> _pages = [Home(), Wishlish(), Cart(), Profile()];

  Widget _buildSvgIcon(String assetName, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SvgPicture.asset(
        assetName,
        height: 24,
        width: 24,
        colorFilter:
            controller.currentIndex.value == index
                ? ColorFilter.mode(AppColor.primary, BlendMode.srcIn)
                : ColorFilter.mode(AppColor.grey, BlendMode.srcIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        CustomDialog.show(
          context: context,
          color: AppColor.primary,
          title: "Đóng ứng dụng",
          content: "Bạn có muốn đóng ứng dụng?",
          onPressed: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.primary,
          elevation: 0,
          title: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.white,
                  ),
                  child: Obx(
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
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Chào mừng",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Obx(
                      () => Text(
                        controller.name.value == ''
                            ? 'Người dùng'
                            : controller.name.value,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, size: 22, color: AppColor.white),
            ),
            const SizedBox(width: 12),
          ],
        ),
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Obx(() => _pages[controller.currentIndex.value]),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Obx(
              () => GNav(
                selectedIndex: controller.currentIndex.value,
                onTabChange: controller.changePage,
                gap: 2,
                color: Colors.grey.shade600,
                activeColor: AppColor.primary,
                tabBackgroundColor: AppColor.primary.withAlpha(25),
                rippleColor: AppColor.primary.withAlpha(30),
                hoverColor: AppColor.primary.withAlpha(20),
                tabBorderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                tabs: [
                  GButton(
                    icon: Icons.circle,
                    iconColor: Colors.transparent,
                    iconActiveColor: Colors.transparent,
                    leading: _buildSvgIcon('assets/icons/tongquan.svg', 0),
                    text: 'Khám phá',
                  ),
                  GButton(
                    icon: Icons.circle,
                    iconColor: Colors.transparent,
                    iconActiveColor: Colors.transparent,
                    leading: _buildSvgIcon('assets/icons/yeuthich.svg', 1),
                    text: 'Yêu thích',
                  ),
                  GButton(
                    icon: Icons.circle,
                    iconColor: Colors.transparent,
                    iconActiveColor: Colors.transparent,
                    leading: _buildSvgIcon('assets/icons/giohang.svg', 2),
                    text: 'Giỏ hàng',
                  ),
                  GButton(
                    icon: Icons.circle,
                    iconColor: Colors.transparent,
                    iconActiveColor: Colors.transparent,
                    leading: _buildSvgIcon('assets/icons/canhan.svg', 3),
                    text: 'Cá nhân',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
