import 'package:flutter/material.dart';
import 'package:utshop/Global/app_color.dart';

class Wishlish extends StatelessWidget {
  const Wishlish({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tên Sản Phẩm Yêu Thích',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '500.000 ₫',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.heart_broken,
                          color: Colors.red,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
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
