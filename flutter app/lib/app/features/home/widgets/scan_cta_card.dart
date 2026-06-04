// ─── Scan CTA Card ────────────────────────────────────────────────────────────

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../controller/home_controller.dart';

class ScanCTACard extends GetView<HomeController> {
  const ScanCTACard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.goToScan,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lets Scan and Eat',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Scan Now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                      ),
                    ),
                  
                ],
              ),
            ),
            const Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
