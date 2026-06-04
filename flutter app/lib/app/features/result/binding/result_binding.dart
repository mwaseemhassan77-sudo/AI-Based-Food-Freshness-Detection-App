// lib/modules/result/bindings/result_binding.dart
import 'package:get/get.dart';
import '../controller/result_controller.dart';

class ResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultController>(() => ResultController());
  }
}