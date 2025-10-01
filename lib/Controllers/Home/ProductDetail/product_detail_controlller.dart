import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  var currentPage = 0.obs;
  RxBool isFavorite = false.obs;
  RxString selectedColor = "".obs;
  RxString selectedSize = ''.obs;
  RxInt selectedQuantity = 1.obs;


  void updatePage(int index) {
    currentPage.value = index;
  }

  void setSize(String size) {
    selectedSize.value = size;
  }

    void incrementQuantity() {
    selectedQuantity.value++;
  }

  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }
}
