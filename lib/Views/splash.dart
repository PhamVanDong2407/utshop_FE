import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utshop/Controllers/splash_controller.dart';
import 'package:utshop/Global/app_color.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Nền trắng
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColor.white,
          ),

          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(seconds: 1),
                  child: Image.asset(
                    'assets/images/logoU.png',
                    width: 110,
                    height: 110,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(seconds: 2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: const [
                        Text(
                          'UTShop',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Thế giới thời trang thể thao trong tay bạn',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
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
