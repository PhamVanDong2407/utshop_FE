import 'package:get/get.dart';

class PopularProductController extends GetxController {
  RxString searchQuery = ''.obs;
  RxString selectedColor = "".obs;
  RxString selectedSize = ''.obs;
  RxInt selectedQuantity = 1.obs;

  void clearSearch() {
    searchQuery.value = '';
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
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
