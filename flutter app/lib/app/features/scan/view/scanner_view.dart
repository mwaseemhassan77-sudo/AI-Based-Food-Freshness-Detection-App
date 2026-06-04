import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/scan_controller.dart';
import '../widgets/scanner_frame.dart';
import '../widgets/bottom_controls.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          Obx(() {
            if (!controller.isCameraReady.value ||
                controller.cameraController == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }
            return CameraPreview(controller.cameraController!);
          }),

          const Center(child: ScannerFrame()),

          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  // ✅ FIXED
                  onPressed: () => Get.toNamed('/home'),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      controller.flashOn.value
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: controller.flashOn.value
                          ? Colors.amber
                          : Colors.white,
                    ),
                    onPressed: controller.toggleFlash,
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          Obx(() {
            if (!controller.isScanning.value) return const SizedBox();
            return Container(
              color: Colors.black87,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }),

          // ✅ Bottom Controls with Capture & Gallery
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomControls(),
          ),
        ],
      ),
    );
  }
}
