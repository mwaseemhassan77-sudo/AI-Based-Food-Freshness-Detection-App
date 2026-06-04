// lib/modules/home/widgets/recent_scan.dart
// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../data/models/scan_result_model.dart';
import '../controller/home_controller.dart';

class RecentScansList extends GetView<HomeController> {
  const RecentScansList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }
      if (controller.recentScans.isEmpty) {
        return const _EmptyState();
      }
      return Column(
        children: controller.recentScans
            .map(
              (scan) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ScanCard(scan: scan),
              ),
            )
            .toList(),
      );
    });
  }
}

// ─── Empty State

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 72,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No scans yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap the scan button to get started',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Scan Card ────────────────────────────────────────────────────────────────

class _ScanCard extends GetView<HomeController> {
  final ScanResultModel scan;
  const _ScanCard({required this.scan});

  void _showDeleteDialog() {
    Get.defaultDialog(
      title: 'Delete Scan',
      middleText: 'Are you sure you want to delete this scan?',
      radius: 12,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleTextStyle: const TextStyle(fontSize: 13),
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteScan(scan);
      },
      onCancel: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MM/dd/yy h:mm a').format(scan.scannedAt);

    return GestureDetector(
      onTap: () => controller.viewScanDetail(scan),
      onLongPress: _showDeleteDialog,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Scanned image (left side, tall) ───────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: SizedBox(
                width: 100,
                height: 110,
                child: scan.imagePath != null && scan.imagePath!.isNotEmpty
                    ? Image.file(
                        File(scan.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imgPlaceholder(),
                      )
                    : _imgPlaceholder(),
              ),
            ),

            // ── Content (right side) ──────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 1, 14, 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date + heart
                    Row(
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),

                        // GestureDetector(
                        //   onTap: () => controller.toggleFavourite(scan),
                        //   child: Icon(
                        //     scan.isFavourite
                        //         ? Icons.favorite_rounded
                        //         : Icons.favorite_border_rounded,
                        //     color: scan.isFavourite
                        //         ? Colors.red.shade300
                        //         : Colors.white.withOpacity(0.6),
                        //     size: 18,
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Food name
                    Text(
                      scan.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // ── Freshness badge (4 states) ─────────────────
                    _FreshnessBadge(scan: scan),

                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => controller.viewScanDetail(scan),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
    color: Colors.white.withOpacity(0.15),
    child: const Center(
      child: Icon(Icons.restaurant_rounded, color: Colors.white, size: 36),
    ),
  );
}

// ─── Freshness Badge — 4 states ───────────────────────────────────────────────

class _FreshnessBadge extends StatelessWidget {
  final ScanResultModel scan;
  const _FreshnessBadge({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: scan.freshnessColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scan.freshnessColor.withOpacity(0.6),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(scan.freshnessIcon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(
            scan.freshnessLabel,
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
