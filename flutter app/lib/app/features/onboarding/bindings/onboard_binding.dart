import 'package:get/get.dart';

import '../controller/onboard_controller.dart';

class OnboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}