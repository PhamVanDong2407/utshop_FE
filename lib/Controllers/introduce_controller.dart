import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Routes/app_page.dart';

class IntroductionController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final pages = [
    {
      'title': "Chào mừng đến với UP Store",
      'description':
          "Khám phá những sản phẩm tốt nhất với mức giá không thể tốt hơn.",
      'imagePath': "assets/images/onbo1.png",
    },
    {
      'title': "Sản phẩm chất lượng",
      'description': "Chúng tôi cung cấp đa dạng các sản phẩm chất lượng cao.",
      'imagePath': "assets/images/onbo2.png",
    },
    {
      'title': "Giao hàng nhanh chóng",
      'description':
          "Đơn hàng sẽ được giao đến tận tay bạn một cách nhanh nhất.",
      'imagePath': "assets/images/onbo3.png",
    },
  ];

  void skip() {
    pageController.animateToPage(
      pages.length - 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void next() {
    if (currentPage.value < pages.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      onFinish();
    }
  }

  void onFinish() {
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
