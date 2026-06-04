// lib/modules/result/views/result_view.dart
// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safebite/core/theme/app_theme.dart';
import '../../home/view/home_view.dart';
import '../controller/result_controller.dart';
import '../widgets/result_not_found.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResultController());
    //  Not recognized
    if (controller.isNotFound) {
      return NotFoundView(imagePath: controller.notFoundImagePath);
    }

    final scan = controller.scan!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.to(const HomeView()),
          child: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Full-width scanned image ───────────────────────
                  _ScannedImageSection(scan: scan),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  Food name
                        Text(
                          scan.displayName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        //  AI confidence
                        Text(
                          '${(scan.foodConfidence * 100).toStringAsFixed(0)}% match confidence',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        //  Freshness card ─────────────────────────────
                        _FreshnessCard(scan: scan),

                        const SizedBox(height: 20),

                        const SizedBox(height: 20),
const SizedBox(height: 100),
                      ],
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

//  Scanned Image Section

class _ScannedImageSection extends GetView<ResultController> {
  final dynamic scan;
  const _ScannedImageSection({required this.scan});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Image
        SizedBox(
          width: double.infinity,
          height: screenH * 0.45,
          child: scan.imagePath != null
              ? Image.file(
                  File(scan.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),

        // Gradient fade at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.white, Colors.white.withOpacity(0)],
              ),
            ),
          ),
        ),

        // Close button
        // Positioned(
        //   top: MediaQuery.of(context).padding.top + 10,
        //   left: 16,
        //   child: GestureDetector(
        //     onTap: () => Get.back(),
        //     child: Container(
        //       width: 38,
        //       height: 38,
        //       decoration: BoxDecoration(
        //         color: Colors.black.withOpacity(0.4),
        //         shape: BoxShape.circle,
        //       ),
        //       child: const Icon(Icons.close, color: Colors.white, size: 20),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _placeholder() => Container(
    color: AppColors.surface,
    child: const Center(
      child: Icon(Icons.restaurant_rounded, color: AppColors.primary, size: 80),
    ),
  );
}

// ─── Freshness Card ───────────────────────────────────────────────────────────

class _FreshnessCard extends StatelessWidget {
  final dynamic scan;
  const _FreshnessCard({required this.scan});

  @override
  Widget build(BuildContext context) {
    // Map label to display-friendly text
    final Map<String, String> labelMap = {
      'Fresh': 'Fresh',
      'Stale': 'Semi Fresh',
      'Rotten': 'Rotten',
    };
    final String displayLabel =
        labelMap[scan.freshnessLabel] ?? scan.freshnessLabel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scan.freshnessColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scan.freshnessColor.withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Big freshness icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: scan.freshnessColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                scan.freshnessIcon,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Label + confidence
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayLabel,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                    color: scan.freshnessColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Freshness detected by AI',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: scan.freshnessColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                // Confidence bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: scan.freshnessConfidence,
                    backgroundColor: scan.freshnessColor.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(scan.freshnessColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(scan.freshnessConfidence * 100).toStringAsFixed(0)}% confident',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    color: scan.freshnessColor.withOpacity(0.7),
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
