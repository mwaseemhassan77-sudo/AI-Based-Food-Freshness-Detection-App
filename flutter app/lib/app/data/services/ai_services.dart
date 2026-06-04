// lib/data/services/ai_services.dart

// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  Interpreter? _foodInterpreter;
  Interpreter? _freshnessInterpreter;

  bool _foodReady = false;
  bool _freshnessReady = false;
  bool _isInitialized = false;

  int _foodInputSize = 224;
  int _freshnessInputSize = 224;
  int _foodOutputSize = 0;
  int _freshnessOutputSize = 0;

  // FIX 2: Raised threshold — model must be 75%+ confident it's a fruit
  static const double _foodThreshold = 0.75;

  // FIX 2: Minimum gap between top-2 predictions
  // If top result is 80% but second is 78%, it's uncertain → reject
  static const double _confidenceGap = 0.15;

  bool get isReady => _foodReady && _freshnessReady;

  static const List<String> fruitLabels = [
    'Apple',
    'Banana',
    'Orange',
    'Mango',
    'Strawberry',
    'Tomato',
    'Cucumber',
    'Potato',
    'Bell Pepper',
    'Carrot',
  ];

  static const List<String> freshnessLabels = ['Fresh', 'Stale', 'Rotten'];

  // ─── INIT ───────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_isInitialized) {
      print("⚠️ AIService already initialized");
      return;
    }

    print("🚀 Initializing AI models...");
    await Future.wait([_loadFoodModel(), _loadFreshnessModel()]);
    _isInitialized = true;

    print("\n📊 ─────── INIT SUMMARY ───────");
    print("   Food model:      ${_foodReady ? '✅ READY' : '❌ FAILED'}");
    print("   Freshness model: ${_freshnessReady ? '✅ READY' : '❌ FAILED'}");
    print("───────────────────────────────\n");
  }

  // ─── LOAD FOOD MODEL ────────────────────────────────────────────────────────

  Future<void> _loadFoodModel() async {
    try {
      const path = 'assets/models/food_name_detect.tflite';
      final options = InterpreterOptions()..threads = 2;

      try {
        _foodInterpreter = await Interpreter.fromAsset(path, options: options);
      } catch (_) {
        final bytes = await _loadBytes(path);
        _foodInterpreter = Interpreter.fromBuffer(bytes, options: options);
      }

      _foodInterpreter!.allocateTensors();

      final inputShape = _foodInterpreter!.getInputTensor(0).shape;
      final outputShape = _foodInterpreter!.getOutputTensor(0).shape;

      _foodInputSize = inputShape.length >= 3 ? inputShape[1] : 224;
      _foodOutputSize = outputShape.length >= 2 ? outputShape[1] : 0;

      print("   ✅ Food model loaded | Input: $inputShape | Output: $outputShape");

      if (_foodOutputSize != fruitLabels.length) {
        print("   ⚠️ Model has $_foodOutputSize classes but ${fruitLabels.length} labels defined!");
      }

      _foodReady = true;
    } catch (e, st) {
      print("   ❌ Food model error: $e\n$st");
      _foodReady = false;
    }
  }

  // ─── LOAD FRESHNESS MODEL ───────────────────────────────────────────────────

  Future<void> _loadFreshnessModel() async {
    try {
      const path = 'assets/models/Food_Freshness.tflite';
      final options = InterpreterOptions()..threads = 2;

      try {
        _freshnessInterpreter = await Interpreter.fromAsset(path, options: options);
      } catch (_) {
        final bytes = await _loadBytes(path);
        _freshnessInterpreter = Interpreter.fromBuffer(bytes, options: options);
      }

      _freshnessInterpreter!.allocateTensors();

      final inputShape = _freshnessInterpreter!.getInputTensor(0).shape;
      final outputShape = _freshnessInterpreter!.getOutputTensor(0).shape;

      _freshnessInputSize = inputShape.length >= 3 ? inputShape[1] : 224;
      _freshnessOutputSize = outputShape.length >= 2 ? outputShape[1] : 0;

      print("   ✅ Freshness model loaded | Input: $inputShape | Output: $outputShape");

      _freshnessReady = true;
    } catch (e, st) {
      print("   ❌ Freshness model error: $e\n$st");
      _freshnessReady = false;
    }
  }

  Future<Uint8List> _loadBytes(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  // ─── MAIN API ───────────────────────────────────────────────────────────────

  Future<AIResult?> analyzeFood(File imageFile) async {
    if (!_isInitialized) await init();
    if (!isReady) return null;

    print("\n🔍 Analyzing: ${imageFile.path}");

    // FIX 1: Always read fresh bytes from disk — never reuse old data
    final imageBytes = await imageFile.readAsBytes();
    if (imageBytes.isEmpty) {
      print("❌ Empty image file");
      return null;
    }

    final input = await _preprocessBytes(imageBytes, _foodInputSize);
    if (input == null) return null;

    final foodOut = await _runFoodModel(input);
    if (foodOut == null) {
      print("❌ Not a recognized fruit (below threshold or low confidence gap)");
      return null;
    }

    print("✅ Food: ${foodOut.label} (${(foodOut.confidence * 100).toStringAsFixed(1)}%)");

    final freshInput = (_foodInputSize == _freshnessInputSize)
        ? input
        : await _preprocessBytes(imageBytes, _freshnessInputSize);

    final freshOut = freshInput != null ? await _runFreshnessModel(freshInput) : null;

    if (freshOut != null) {
      print("✅ Freshness: ${freshOut.label} (${(freshOut.confidence * 100).toStringAsFixed(1)}%)");
    }

    return AIResult(
      foodLabel: foodOut.label,
      foodConfidence: foodOut.confidence,
      freshnessLabel: freshOut?.label ?? 'Fresh',
      freshnessConfidence: freshOut?.confidence ?? 1.0,
      isFresh: (freshOut?.label ?? 'Fresh') == 'Fresh',
    );
  }

  // ─── FOOD MODEL RUN ─────────────────────────────────────────────────────────

  Future<_ModelOut?> _runFoodModel(List input) async {
    if (!_foodReady || _foodInterpreter == null) return null;

    try {
      final output = [List<double>.filled(_foodOutputSize, 0.0)];
      _foodInterpreter!.run(input, output);

      final scores = List<double>.from(output[0]);

      // FIX 2: Check confidence threshold
      final out = _argmax(scores, fruitLabels);
      if (out.confidence < _foodThreshold) {
        print("❌ Confidence too low: ${(out.confidence * 100).toStringAsFixed(1)}% < ${(_foodThreshold * 100).toStringAsFixed(0)}%");
        return null;
      }

      // FIX 2: Check confidence gap between top 2 predictions
      // If two predictions are too close, the model is uncertain
      final sortedScores = List<double>.from(scores)..sort((a, b) => b.compareTo(a));
      if (sortedScores.length >= 2) {
        final gap = sortedScores[0] - sortedScores[1];
        if (gap < _confidenceGap) {
          print("❌ Confidence gap too small: ${(gap * 100).toStringAsFixed(1)}% < ${(_confidenceGap * 100).toStringAsFixed(0)}% — likely not a fruit");
          return null;
        }
      }

      return out;
    } catch (e, st) {
      print("❌ Food inference error: $e\n$st");
      return null;
    }
  }

  // ─── FRESHNESS MODEL RUN ────────────────────────────────────────────────────

  Future<_ModelOut?> _runFreshnessModel(List input) async {
    if (!_freshnessReady || _freshnessInterpreter == null) return null;

    try {
      final output = [List<double>.filled(_freshnessOutputSize, 0.0)];
      _freshnessInterpreter!.run(input, output);

      final scores = List<double>.from(output[0]);

      if (_freshnessOutputSize == 1) {
        final score = scores[0];
        final isFresh = score < 0.5;
        return _ModelOut(
          label: isFresh ? 'Fresh' : 'Rotten',
          confidence: isFresh ? (1 - score) : score,
        );
      }

      if (_freshnessOutputSize == 2) {
        return _argmax(scores, ['Fresh', 'Rotten']);
      }

      return _argmax(scores, freshnessLabels);
    } catch (e, st) {
      print("❌ Freshness inference error: $e\n$st");
      return null;
    }
  }

  // ─── IMAGE PREPROCESSING ────────────────────────────────────────────────────

  // FIX 1: Takes raw bytes instead of File — ensures fresh data every scan
  Future<List?> _preprocessBytes(Uint8List bytes, int targetSize) async {
    try {
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: targetSize,
        targetHeight: targetSize,
      );

      // FIX 1: Always get a fresh frame — do not cache codec or frame
      final frame = await codec.getNextFrame();
      final byteData = await frame.image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      // FIX 1: Dispose image after use to free memory
      frame.image.dispose();

      if (byteData == null) return null;

      final rgba = byteData.buffer.asUint8List();

      return [
        List.generate(targetSize, (y) {
          return List.generate(targetSize, (x) {
            final i = (y * targetSize + x) * 4;
            return [
              rgba[i] / 255.0,
              rgba[i + 1] / 255.0,
              rgba[i + 2] / 255.0,
            ];
          });
        }),
      ];
    } catch (e, st) {
      print("❌ Preprocess error: $e\n$st");
      return null;
    }
  }

  // ─── ARGMAX ─────────────────────────────────────────────────────────────────

  _ModelOut _argmax(List<double> scores, List<String> labels) {
    if (scores.isEmpty) return const _ModelOut(label: 'Unknown', confidence: 0.0);

    double max = scores[0];
    int index = 0;

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > max) {
        max = scores[i];
        index = i;
      }
    }

    return _ModelOut(
      label: index < labels.length ? labels[index] : 'Unknown',
      confidence: max,
    );
  }

  // ─── DISPOSE ────────────────────────────────────────────────────────────────

  void dispose() {
    _foodInterpreter?.close();
    _freshnessInterpreter?.close();
    _foodInterpreter = null;
    _freshnessInterpreter = null;
    _foodReady = false;
    _freshnessReady = false;
    _isInitialized = false;
    print("🧹 AIService disposed");
  }
}

// ─── INTERNAL MODELS ────────────────────────────────────────────────────────

class _ModelOut {
  final String label;
  final double confidence;
  const _ModelOut({required this.label, required this.confidence});
}

class AIResult {
  final String foodLabel;
  final double foodConfidence;
  final String freshnessLabel;
  final double freshnessConfidence;
  final bool isFresh;

  const AIResult({
    required this.foodLabel,
    required this.foodConfidence,
    required this.freshnessLabel,
    required this.freshnessConfidence,
    required this.isFresh,
  });

  String get displayFoodName => foodLabel
      .split('_')
      .map((e) => e.isEmpty ? e : e[0].toUpperCase() + e.substring(1))
      .join(' ');

  String get displayName => displayFoodName;
  String get foodConfidencePercent => '${(foodConfidence * 100).toStringAsFixed(1)}%';
  String get freshnessConfidencePercent => '${(freshnessConfidence * 100).toStringAsFixed(1)}%';

  double get healthRating {
    if (isFresh) return 5.0;
    if (freshnessLabel == 'Stale') return 2.5;
    return 1.0;
  }

  Color get freshnessColor {
    switch (freshnessLabel) {
      case 'Fresh': return const Color(0xFF43A047);
      case 'Stale': return const Color(0xFFFFB300);
      case 'Rotten': return const Color(0xFFE53935);
      default: return const Color(0xFF757575);
    }
  }

  String get freshnessIcon {
    switch (freshnessLabel) {
      case 'Fresh': return '✅';
      case 'Stale': return '⚠️';
      case 'Rotten': return '❌';
      default: return '❓';
    }
  }

  String get suggestion {
    if (isFresh) return 'This $displayName is fresh and ready to eat. Good nutritional choice!';
    if (freshnessLabel == 'Stale') return 'This $displayName is getting stale. Consider consuming it soon or store it properly.';
    return 'This $displayName appears to be rotten. Do not consume it.';
  }
}