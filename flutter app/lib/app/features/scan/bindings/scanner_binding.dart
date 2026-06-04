// lib/modules/scan/bindings/scan_binding.dart
import 'package:get/get.dart';
import '../controller/scan_controller.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(() => ScanController());
  }
}