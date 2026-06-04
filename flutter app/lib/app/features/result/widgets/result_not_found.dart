//  Not Found Screen

// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../controller/result_controller.dart';

class NotFoundView extends GetView<ResultController> {
  final String? imagePath;
  const NotFoundView({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Close
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.close,
                    size: 26,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    //  Scanned image 
                    if (imagePath != null)
                      Container(
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.surface,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: AppColors.textSecondary,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    //  Search icon 
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 44,
                        color: Colors.grey.shade400,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //  Title 
                    const Text(
                      'Not a Fruit',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    //  Subtitle 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'This item is not a fruit or is unknown.\nPlease scan a fruit item like apple, banana, or mango.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontFamily: 'Poppins',
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 150),

                    //  Scan Again button 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.scanAgain,
                          icon: const Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 20,
                          ),
                          label: const Text(
                            'Scan Again',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: controller.goHome,
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

