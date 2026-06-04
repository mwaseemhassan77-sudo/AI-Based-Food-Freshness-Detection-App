// lib/core/constants/app_constants.dart

class AppConstants {
  static const String appName = 'Fruit Freshness Detector';
  static const String appVersion = '1.0.0';

  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyUserName = 'user_name';
  static const String keyUserAvatar = 'user_avatar';
  static const String keyTotalScans = 'total_scans';

  static const String dbName = 'safebite.db';
  static const int dbVersion = 3; // ← bumped: adds isFavourite column
  static const String tableScans = 'scans';

  static const String foodNameModelPath =
      'assets/models/food_name_detect.tflite';
  static const String freshnessModelPath =
      'assets/models/Food_Freshness.tflite';
  static const int inputSize = 224;
  static const double confidenceThreshold = 0.55;

 


  static double getHealthRating(Map<String, double> n) {
    double score = 5.0;
    if (n['cholesterol']! > 60) score -= 0.8;
    if (n['fat']! > 15) score -= 0.5;
    if (n['unsatFat']! > 5) score -= 0.3;
    if (n['protein']! > 15) score += 0.3;
    if (n['calories']! < 150) score += 0.3;
    return score.clamp(1.0, 5.0);
  }


  static String getSuggestion(Map<String, double> n, [String freshness = 'Fresh']) {
    if (freshness == 'Rotten') {
      return '⚠️ This food appears spoiled. Consuming it may cause illness. Please discard immediately.';
    }
    if (freshness == 'Stale') {
      return '⚠️ This food appears stale. Consume with caution or avoid if unsure.';
    }
    if (n['cholesterol']! > 60) {
      return 'This meal is high in cholesterol. Consider balancing with fiber-rich vegetables.';
    }
    if (n['protein']! > 15) {
      return 'Great protein content! Supports muscle recovery. Pair with complex carbs for best results.';
    }
    return 'A balanced meal. Watch portion size and complement with fresh fruits or vegetables.';
  }
}