import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  var currentPage = 0.obs;
  RxBool isFavorite = false.obs;
  RxString selectedColor = "".obs;
  RxString selectedSize = ''.obs;

  void updatePage(int index) {
    currentPage.value = index;
  }

  void setSize(String size) {
    selectedSize.value = size;
  }
}
