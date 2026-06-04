// lib/data/repository/scan_repository.dart
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/scan_result_model.dart';
import '../services/ai_services.dart';
import '../services/database_services.dart';
import '../services/storage_services.dart';

class ScanRepository {
  final AIService _ai = AIService();
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();
  final _uuid = const Uuid();

  // Define the labels that should be considered 'fruits' for this app.
  // If the model predicts a label outside this set, we treat the item as
  // "not a fruit" and return null so the UI shows the NotFound flow.
  static const Set<String> _fruitOnly = {
    'Apple',
    'Banana',
    'Orange',
    'Mango',
    'Strawberry',
  };

  /// Returns null when scanned item not recognized by model
  Future<ScanResultModel?> scanFood(File imageFile) async {
    final aiResult = await _ai.analyzeFood(imageFile);
    if (aiResult == null) return null;

    // If model predicted a label but it's not in our fruit-only list,
    // treat it as not recognized for this app.
    if (!_isFruitLabel(aiResult.foodLabel)) return null;

    final scan = _createScanFromResult(aiResult, imageFile.path);
    await _db.insertScan(scan);
    _storage.incrementScans();
    return scan;
  }

  Future<ScanResultModel?> saveScanFromAI(
    AIResult aiResult,
    String imagePath,
  ) async {
    if (!_isFruitLabel(aiResult.foodLabel)) return null;

    final scan = _createScanFromResult(aiResult, imagePath);
    await _db.insertScan(scan);
    _storage.incrementScans();
    return scan;
  }

  bool _isFruitLabel(String label) {
    // Normalize label for comparison
    final normalized = label.trim();
    return _fruitOnly.contains(normalized);
  }

  ScanResultModel _createScanFromResult(AIResult aiResult, String imagePath) {
    return ScanResultModel(
      id: _uuid.v4(),
      foodLabel: aiResult.foodLabel,
      imagePath: imagePath,
      freshnessLabel: aiResult.freshnessLabel,
      freshnessConfidence: aiResult.freshnessConfidence,
      isFresh: aiResult.isFresh,
      foodConfidence: aiResult.foodConfidence,
      scannedAt: DateTime.now(),
    );
  }

  Future<List<ScanResultModel>> getRecentScans() => _db.getAllScans();

  Future<List<ScanResultModel>> getFavourites() => _db.getFavourites();

  /// Toggle favourite state in DB, returns updated model
  Future<ScanResultModel> toggleFavourite(ScanResultModel scan) async {
    final updated = scan.copyWith(isFavourite: !scan.isFavourite);
    await _db.updateFavourite(scan.id, updated.isFavourite);
    return updated;
  }

  Future<void> deleteScan(String id) => _db.deleteScan(id);
}
