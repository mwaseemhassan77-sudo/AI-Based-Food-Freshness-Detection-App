// lib/data/models/scan_result_model.dart
import 'package:flutter/material.dart';

class ScanResultModel {
  final String id;
  final String foodLabel;
  final String? imagePath;
  final DateTime scannedAt;
  final String freshnessLabel;
  final double freshnessConfidence;
  final bool isFresh;
  final double foodConfidence;
  final bool isFavourite;

  ScanResultModel({
    required this.id,
    required this.foodLabel,
    this.imagePath,
    required this.scannedAt,
    this.freshnessLabel = 'Fresh',
    this.freshnessConfidence = 1.0,
    this.isFresh = true,
    this.foodConfidence = 1.0,
    this.isFavourite = false,
  });

  /// Returns a copy with changed fields
  ScanResultModel copyWith({bool? isFavourite}) => ScanResultModel(
    id: id,
    foodLabel: foodLabel,
    imagePath: imagePath,
    scannedAt: scannedAt,
    freshnessLabel: freshnessLabel,
    freshnessConfidence: freshnessConfidence,
    isFresh: isFresh,
    foodConfidence: foodConfidence,
    isFavourite: isFavourite ?? this.isFavourite,
  );

  String get displayName => foodLabel
      .split('_')
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');

  Color get freshnessColor {
    switch (freshnessLabel) {
      case 'Fresh':
        return const Color(0xFF43A047);
      case 'Stale':
        return const Color(0xFFFFB300);
      case 'Rotten':
        return const Color(0xFFE53935);
      default:
        return const Color.fromARGB(255, 225, 218, 218);
    }
  }

  String get freshnessIcon {
    switch (freshnessLabel) {
      case 'Fresh':
        return '✅';
      case 'Stale':
        return '⚠️';
      case 'Rotten':
        return '❌';
      default:
        return '❓';
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'foodLabel': foodLabel,
    'imagePath': imagePath,
    'scannedAt': scannedAt.toIso8601String(),
    'freshnessLabel': freshnessLabel,
    'freshnessConfidence': freshnessConfidence,
    'isFresh': isFresh ? 1 : 0,
    'foodConfidence': foodConfidence,
    'isFavourite': isFavourite ? 1 : 0,
  };

  factory ScanResultModel.fromMap(Map<String, dynamic> m) => ScanResultModel(
    id: m['id'],
    foodLabel: m['foodLabel'],
    imagePath: m['imagePath'],
    scannedAt: DateTime.parse(m['scannedAt']),
    freshnessLabel: m['freshnessLabel'] ?? 'Fresh',
    freshnessConfidence: (m['freshnessConfidence'] as num?)?.toDouble() ?? 1.0,
    isFresh: (m['isFresh'] ?? 1) == 1,
    foodConfidence: (m['foodConfidence'] as num?)?.toDouble() ?? 1.0,
    isFavourite: (m['isFavourite'] ?? 0) == 1,
  );
}
