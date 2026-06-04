// lib/modules/home/controller/home_controller.dart
import 'package:get/get.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../data/models/scan_result_model.dart';
import '../../../data/repository/scan_repository.dart';
import '../../../data/services/storage_services.dart';

class HomeController extends GetxController {
  final _repo = ScanRepository();
  final _storage = StorageService();

  final recentScans = <ScanResultModel>[].obs;
  final isLoading = false.obs;
  final selectedTabIndex = 0.obs;

  String get userName => _storage.userName;
  int get totalScans => _storage.totalScans;

  @override
  void onInit() {
    super.onInit();
    loadRecentScans();
  }

  Future<void> loadRecentScans() async {
    isLoading.value = true;
    try {
      final scans = await _repo.getRecentScans();
      recentScans.assignAll(scans);
    } finally {
      isLoading.value = false;
    }
  }

  void goToScan() => Get.toNamed(AppRoutes.scan);

  void viewScanDetail(ScanResultModel scan) =>
      Get.toNamed(AppRoutes.result, arguments: scan);

  /// Toggle favourite — updates DB + reactive list in place
  Future<void> toggleFavourite(ScanResultModel scan) async {
    final updated = await _repo.toggleFavourite(scan);
    final idx = recentScans.indexWhere((s) => s.id == scan.id);
    if (idx != -1) {
      recentScans[idx] = updated;
      recentScans.refresh();
    }
    Get.snackbar(
      updated.isFavourite
          ? '❤️ Added to Favourites'
          : 'Removed from Favourites',
      updated.isFavourite
          ? '${updated.displayName} saved to favourites'
          : '${updated.displayName} removed from favourites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> deleteScan(ScanResultModel scan) async {
    await _repo.deleteScan(scan.id);
    recentScans.remove(scan);
    recentScans.refresh();
    Get.snackbar(
      'Deleted',
      'Scan removed successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;

    if (index == 1) {
      if (Get.currentRoute != AppRoutes.scan) {
        Get.toNamed(AppRoutes.scan);
      }
      return;
    }

    if (index == 2) {
      if (Get.currentRoute != AppRoutes.chatBoat) {
        Get.toNamed(AppRoutes.chatBoat);
      }
      return;
    }

    if (Get.currentRoute != AppRoutes.home) {
      Get.offNamed(AppRoutes.home);
    }
  }
}
