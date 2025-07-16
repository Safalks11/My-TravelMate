import 'package:get/get.dart';

class CustomSearchController extends GetxController {
  RxBool isSearching = false.obs;

  void startSearching() {
    isSearching.value = true;
  }

  void stopSearching() {
    isSearching.value = false;
  }
}
