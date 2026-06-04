// lib/modules/result/controller/result_controller.dart
// ignore_for_file: file_names

import 'package:get/get.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../data/models/scan_result_model.dart';
import '../../../data/repository/scan_repository.dart';

class ResultController extends GetxController {
  final _repo = ScanRepository();

  ScanResultModel? scan;
  bool isNotFound = false;
  String? notFoundImagePath;

  // Reactive favourite state — synced with model
  final isFavourite = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ScanResultModel) {
      scan = args;
      isNotFound = false;
      isFavourite.value = scan!.isFavourite;
    } else if (args is Map && args['notFound'] == true) {
      scan = null;
      isNotFound = true;
      notFoundImagePath = args['imagePath'] as String?;
    }
  }

  /// Toggle favourite — persists to DB, updates reactive state
  Future<void> toggleFavourite() async {
    if (scan == null) return;
    final updated = await _repo.toggleFavourite(scan!);
    scan = updated;
    isFavourite.value = updated.isFavourite;

    Get.snackbar(
      updated.isFavourite ? '❤️ Added to Favourites' : 'Removed from Favourites',
      updated.isFavourite
          ? '${updated.displayName} saved to favourites'
          : '${updated.displayName} removed from favourites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void goHome() => Get.offAllNamed(AppRoutes.home);
  void scanAgain() => Get.offNamed(AppRoutes.scan);

  Future<void> deleteScan() async {
    if (scan == null) return;
    await _repo.deleteScan(scan!.id);
    Get.back();
    Get.snackbar('Deleted', 'Scan removed from history.',
        snackPosition: SnackPosition.BOTTOM);
  }
}