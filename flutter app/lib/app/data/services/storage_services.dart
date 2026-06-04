// lib/core/utils/storage_service.dart
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constant.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final GetStorage _box;
  late final SharedPreferences _prefs;

  Future<void> init() async {
    await GetStorage.init('SafeBiteStorage');
    _box = GetStorage('SafeBiteStorage');
    _prefs = await SharedPreferences.getInstance();
  }

  // ─── GetStorage (fast, reactive) ────────────────────────────────────────────
  void setOnboardingDone(bool value) => _box.write(AppConstants.keyOnboardingDone, value);
  bool get isOnboardingDone => _box.read<bool>(AppConstants.keyOnboardingDone) ?? false;

  void setTotalScans(int count) => _box.write(AppConstants.keyTotalScans, count);
  int get totalScans => _box.read<int>(AppConstants.keyTotalScans) ?? 0;
  void incrementScans() => setTotalScans(totalScans + 1);

  // ─── SharedPreferences (user profile, persistent settings) ──────────────────
  Future<void> setUserName(String name) async =>
      await _prefs.setString(AppConstants.keyUserName, name);
  String get userName => _prefs.getString(AppConstants.keyUserName) ?? 'User';

  Future<void> setUserAvatar(String path) async =>
      await _prefs.setString(AppConstants.keyUserAvatar, path);
  String? get userAvatar => _prefs.getString(AppConstants.keyUserAvatar);

  // ─── Notifications ──────────────────────────────────────────────────────────
  Future<void> setNotificationsEnabled(bool value) async =>
      await _prefs.setBool('notifications_enabled', value);
  bool get notificationsEnabled => _prefs.getBool('notifications_enabled') ?? true;

  // ─── Clear ──────────────────────────────────────────────────────────────────
  Future<void> clearAll() async {
    await _box.erase();
    await _prefs.clear();
  }
}