import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:utshop/Controllers/introduce_controller.dart';

class IntroductionScreen extends StatelessWidget {
  IntroductionScreen({super.key});
  final controller = Get.put(IntroductionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: controller.pages.length,
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              final page = controller.pages[index];
              return Introduce(
                title: page['title']!,
                description: page['description']!,
                imagePath: page['imagePath']!,
              );
            },
          ),
          Obx(
            () =>
                controller.currentPage.value == controller.pages.length - 1
                    ? const SizedBox.shrink()
                    : Positioned(
                      bottom: 40,
                      left: 20,
                      child: SizedBox(
                        width: 100,
                        child: TextButton(
                          onPressed: () {
                            controller.skip();
                          },
                          child: const Text(
                            "Bỏ qua",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: Obx(
              () => SizedBox(
                width: 120,
                child: TextButton(
                  onPressed: () {
                    controller.next();
                  },
                  child: Text(
                    controller.currentPage.value == controller.pages.length - 1
                        ? "Kết thúc"
                        : "Tiếp theo",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // SmoothPageIndicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: SizedBox(
              height: 20,
              child: Center(
                child: SmoothPageIndicator(
                  controller: controller.pageController,
                  count: controller.pages.length,
                  effect: const WormEffect(
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Introduce extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const Introduce({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 300,
          errorBuilder:
              (context, error, stackTrace) => const Text(
                'Error loading image',
                style: TextStyle(color: Colors.red),
              ),
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
