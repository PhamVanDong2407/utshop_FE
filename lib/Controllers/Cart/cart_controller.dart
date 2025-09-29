import 'package:get/get.dart';

class CartController extends GetxController {
  RxInt selectedQuantity = 1.obs;

    void incrementQuantity() {
    selectedQuantity.value++;
  }

  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }
}