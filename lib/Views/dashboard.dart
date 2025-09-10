import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:utshop/Components/custom_dialog.dart';
import 'package:utshop/Controllers/dashboard_controller.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Utils/device_helper.dart';
import 'package:utshop/Views/Cart/cart.dart';
import 'package:utshop/Views/Home/home.dart';
import 'package:utshop/Views/Profile/profile.dart';
import 'package:utshop/Views/Wishlist/wishlish.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final controller = Get.put(DashboardController());

  // Danh sách các màn hình tương ứng với các tab
  final List<Widget> _pages = [Home(), Wishlish(), Cart(), Profile()];

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
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Obx(() => _pages[controller.currentIndex.value]),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColor.text1.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: controller.changePage,
                backgroundColor: AppColor.main,
                selectedItemColor: AppColor.primary,
                unselectedItemColor: AppColor.grey,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: DeviceHelper.getFontSize(14),
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: DeviceHelper.getFontSize(14),
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: _buildSvgIcon('assets/icons/tongquan.svg', 0),
                    label: 'Tổng quan',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildSvgIcon('assets/icons/yeuthich.svg', 1),
                    label: 'Yêu thích',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildSvgIcon('assets/icons/giohang.svg', 2),
                    label: 'Giỏ hàng',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildSvgIcon('assets/icons/canhan.svg', 3),
                    label: 'Cá nhân',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
