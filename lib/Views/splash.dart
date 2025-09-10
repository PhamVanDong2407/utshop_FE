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
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColor.white,
          ),

          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logoU.png', width: 100, height: 100),
                const SizedBox(height: 20),
                const Text(
                  'Chào mừng bạn đến với UTShop',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
