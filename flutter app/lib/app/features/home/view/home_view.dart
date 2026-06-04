// lib/modules/home/views/home_view.dart
// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safebite/app/features/moredetails/details.dart';
import 'package:safebite/core/theme/app_theme.dart';
import '../controller/home_controller.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/circle_painter.dart';
import '../widgets/recent_scan.dart';
import '../widgets/scan_cta_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.loadRecentScans,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _HeroBanner(),
                      const SizedBox(height: 16),
                      const ScanCTACard(),
                      const SizedBox(height: 24),
                      _RecentScansHeader(),
                      const SizedBox(height: 14),
                      const RecentScansList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

// ─── Hero Banner ──────────────────────────────────────────────────────────────

class _HeroBanner extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomPaint(painter: CirclePatternPainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     // CircleAvatar(
                //     //   radius: 22,
                //     //   backgroundColor: Colors.white.withOpacity(0.3),
                //     //   // child: const Icon(
                //     //   //   Icons.person,
                //     //   //   color: Colors.white,
                //     //   //   size: 24,
                //     //   // ),
                //     // ),
                //     // const Spacer(),
                //     // Container(
                //     //   padding: const EdgeInsets.symmetric(
                //     //     horizontal: 14,
                //     //     vertical: 7,
                //     //   ),
                //     //   decoration: BoxDecoration(
                //     //     color: Colors.white.withOpacity(0.2),
                //     //     borderRadius: BorderRadius.circular(20),
                //     //     border: Border.all(
                //     //       color: Colors.white.withOpacity(0.4),
                //     //     ),
                //     //   ),
                //     //   child: Row(
                //     //     children: const [
                //     //       Icon(
                //     //         Icons.notifications_outlined,
                //     //         color: Colors.white,
                //     //         size: 16,
                //     //       ),
                //     //       SizedBox(width: 6),
                //     //       Text(
                //     //         'Notification',
                //     //         style: TextStyle(
                //     //           color: Colors.white,
                //     //           fontSize: 12,
                //     //           fontFamily: 'Poppins',
                //     //           fontWeight: FontWeight.w500,
                //     //         ),
                //     //       ),
                //     //     ],
                //     //   ),
                //     // ),
                //   ],
                // ),
                // const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/food_placeholder.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Scan Your Fruit in Seconds',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Identify items instantly with AI',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: (){
                    Get.to(AboutApplicationScreen());
                  },
                  child: Row(
                    children: const [
                      Text(
                        'More Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.open_in_new, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recent Scans Header ──────────────────────────────────────────────────────

class _RecentScansHeader extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Recent Scan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Icon(Icons.filter_list_rounded, color: AppColors.textSecondary),
      ],
    );
  }
}
