// lib/modules/splash/controller/splash_controller.dart
// ignore_for_file: unused_import, unused_field

import 'package:get/get.dart';
import 'package:safebite/app/features/onboarding/view/onboard_view.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../data/services/storage_services.dart';

class SplashController extends GetxController {
  final _storage = StorageService();
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    if (_storage.isOnboardingDone) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
