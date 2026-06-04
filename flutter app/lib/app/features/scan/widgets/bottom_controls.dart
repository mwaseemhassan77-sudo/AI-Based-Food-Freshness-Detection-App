// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../controller/scan_controller.dart';

class BottomControls extends GetView<ScanController> {
  const BottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      
        children: [
          
          // Gallery pick button (left)
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: GestureDetector(
              onTap: controller.pickFromGallery,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.surface,
                ),
                child: const Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
          ),
          

          // Manual capture button (center)
          GestureDetector(
            onTap: controller.captureAndScan,
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isScanning.value
                      ? AppColors.primary.withOpacity(0.6)
                      : Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: controller.isScanning.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
              ),
            ),
          ),
        SizedBox(width: 45),

       
        ],
      ),
    );
  }
}
