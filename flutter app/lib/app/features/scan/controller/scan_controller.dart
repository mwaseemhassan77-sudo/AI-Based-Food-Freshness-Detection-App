// lib/modules/scan/controller/scan_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/repository/scan_repository.dart';
import '../../../data/services/ai_services.dart';
import '../../result/view/result_view.dart';

// class ScanController extends GetxController {

//   final _repo = ScanRepository();
//   final _picker = ImagePicker();

//   CameraController? cameraController;
//   final isCameraReady = false.obs;
//   final isScanning = false.obs;
//   final lastImagePath = ''.obs;
//   final flashOn = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _initCamera();
//   }

//   Future<void> _initCamera() async {
//     final status = await Permission.camera.request();
//     if (!status.isGranted) {
//       Get.snackbar(
//         'Permission Required',
//         'Camera permission is needed to scan food.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade600,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) return;

//       cameraController = CameraController(
//         cameras.first,
//         ResolutionPreset.high,
//         enableAudio: false,
//       );
//       await cameraController!.initialize();
//       isCameraReady.value = true;
//     } catch (e) {
//       Get.snackbar(
//         'Camera Error',
//         'Could not initialize camera: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<void> toggleFlash() async {
//     if (cameraController == null) return;
//     flashOn.value = !flashOn.value;
//     await cameraController!.setFlashMode(
//       flashOn.value ? FlashMode.torch : FlashMode.off,
//     );
//   }

//   Future<void> captureAndScan() async {
//     if (cameraController == null ||
//         !isCameraReady.value ||
//         isScanning.value) return;

//     isScanning.value = true;
//     try {
//       final xFile = await cameraController!.takePicture();
//       lastImagePath.value = xFile.path;
//       await _processScan(File(xFile.path));
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to capture image.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isScanning.value = false;
//     }
//   }

//   Future<void> pickFromGallery() async {
//     final status = await Permission.photos.request();
//     if (!status.isGranted) {
//       Get.snackbar(
//         'Permission Required',
//         'Gallery permission is needed.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade600,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isScanning.value = true;
//     try {
//       final xFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//       );
//       // null = user cancelled picker — finally handles isScanning reset
//       if (xFile == null) return;

//       lastImagePath.value = xFile.path;
//       await _processScan(File(xFile.path));
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick image.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isScanning.value = false;
//     }
//   }

//   Future<void> _processScan(File imageFile) async {
//     try {
//       final result = await _repo.scanFood(imageFile);

//       if (result == null) {
//         // Food not recognized by the model
//         Get.toNamed(
//           AppRoutes.result,
//           arguments: {
//             'notFound': true,
//             'imagePath': imageFile.path,
//           },
//         );
//       } else {
//         // Food recognized — pass full ScanResultModel
//         Get.toNamed(AppRoutes.result, arguments: result);
//       }
//     } catch (_) {
//       Get.snackbar(
//         'Scan Failed',
//         'Could not analyze the image. Try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade600,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   void onClose() {
//     cameraController?.dispose();
//     super.onClose();
//   }
// }

class ScanController extends GetxController with WidgetsBindingObserver {
  final AIService _aiService = AIService();
  final ScanRepository _repo = ScanRepository();
  final _picker = ImagePicker();

  CameraController? cameraController;
  final isCameraReady = false.obs;
  final isScanning = false.obs;
  final lastImagePath = ''.obs;
  final flashOn = false.obs;

  bool _isProcessing = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initCameraAndService();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app is backgrounded/closed or becomes inactive, ensure the
    // flashlight is turned off to avoid leaving the torch on.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      try {
        cameraController?.setFlashMode(FlashMode.off);
      } catch (_) {
        
      }
      flashOn.value = false;
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _initCameraAndService() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      Get.snackbar(
        'Permission Required',
        'Camera permission is needed to scan food.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _aiService.init();
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraReady.value = true;
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Could not initialize camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> toggleFlash() async {
    if (cameraController == null) return;
    flashOn.value = !flashOn.value;
    await cameraController!.setFlashMode(
      flashOn.value ? FlashMode.torch : FlashMode.off,
    );
  }

  /// Manual capture button — take picture when user taps
  Future<void> captureAndScan() async {
    if (cameraController == null ||
        !isCameraReady.value ||
        isScanning.value ||
        _isProcessing)
      return;

    _isProcessing = true;
    isScanning.value = true;

    try {
      final xFile = await cameraController!.takePicture();
      lastImagePath.value = xFile.path;
      await _processScan(File(xFile.path));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isScanning.value = false;
    } finally {
      _isProcessing = false;
    }
  }

  /// Gallery picker — select image from phone storage
  Future<void> pickFromGallery() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      Get.snackbar(
        'Permission Required',
        'Gallery permission is needed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (isScanning.value || _isProcessing) return;

    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (xFile == null) return;

      isScanning.value = true;
      _isProcessing = true;
      lastImagePath.value = xFile.path;
      await _processScan(File(xFile.path));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isScanning.value = false;
    } finally {
      _isProcessing = false;
    }
  }

  /// Process scan result and navigate
  Future<void> _processScan(File imageFile) async {
    try {
      final result = await _repo.scanFood(imageFile);

      if (result == null) {
        // Food not recognized by the model
        Get.to(
          () => const ResultView(),
          arguments: {'notFound': true, 'imagePath': imageFile.path},
        );
      } else {
        // Food recognized — pass full ScanResultModel
        Get.to(() => const ResultView(), arguments: result);
      }
    } catch (e) {
      Get.snackbar(
        'Scan Failed',
        'Could not analyze the image. Try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isScanning.value = false;
    }
  }

  @override
  void onClose() {
    try {
      cameraController?.setFlashMode(FlashMode.off);
    } catch (_) {}
    flashOn.value = false;
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.onClose();
  }
}
