// lib/modules/onboarding/controllers/onboarding_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_pages.dart';
import '../../../data/services/storage_services.dart';

class OnboardingPage {
  final String title;
  final String description;
  final String image;
  final Color bgColor;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.bgColor,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final pages = const [
    OnboardingPage(
      title: 'Scan Food in Seconds',
      description:
          'Use AI to identify any food instantly—just point your camera and scan.',
      image: 'assets/images/onbard-2.png',
      bgColor: Color(0xFF1B5E20),
    ),
    OnboardingPage(
      title: 'Stay Safe with Instant Alerts',
      description:
          'Detect allergens, additives, and hidden ingredients before you eat.',
      image: 'assets/images/onboard.png',
      bgColor: Color(0xFF2E7D32),
    ),
    OnboardingPage(
      title: 'Know What’s Inside Your Meal',
      description:
          'Calories, nutrients, food quality score—everything in one tap.',
      image: 'assets/images/onboard-3.png',
      bgColor: Color(0xFF2E7D32),
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      finish();
    }
  }

  void finish() {
    StorageService().setOnboardingDone(true);
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
