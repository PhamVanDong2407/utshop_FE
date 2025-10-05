import 'package:get/get.dart';

class VoucherController extends GetxController {
  RxBool isExpanded = false.obs;

  void toggleExpand() {
    isExpanded.value = !isExpanded.value;
  }
}
