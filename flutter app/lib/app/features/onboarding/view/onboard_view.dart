// lib/modules/onboarding/views/onboarding_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/onboard_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OnboardingController());
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (i) => controller.currentPage.value = i,
            itemCount: controller.pages.length,
            itemBuilder: (_, i) => _OnboardingPage(page: controller.pages[i]),
          ),
          // Bottom controls
          Positioned(
            bottom: 70,
            left: 24,
            right: 24,
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey.withOpacity(0.9),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 6,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        border: Border.all(color: Colors.white, width: 1.2),
                        shape: BoxShape.circle,
                      ),
                      child: ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                        ),
                        child: Text(
                          controller.currentPage.value ==
                                  controller.pages.length - 1
                              ? 'Done'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final dynamic page;
  const _OnboardingPage({required this.page});

  @override
  Widget build(BuildContext context) {
    // Get status bar height manually — we apply it only where needed
    // so NO SafeArea ever touches the image section
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [page.bgColor, const Color(0xFF2E7D32)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.7],
        ),
      ),
      // Use a plain Column with NO SafeArea wrapping it
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status bar space + Logo ────────────────────────────────
          // Apply top padding manually — only here, not globally
          SizedBox(height: topPadding + 8),
          Center(
            child: Text(
              'Fruit Fressness\n Detector',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 280,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Image.asset(
                    'assets/images/onboard-back.png',
                    width: 270,
                    height: 280,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 15,
                  child: Image.asset(
                    page.image,
                    width: 255,
                    height: 250,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Title & description — padded normally ──────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              page.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: 'Poppins',
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              page.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.75),
                fontFamily: 'Poppins',
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
