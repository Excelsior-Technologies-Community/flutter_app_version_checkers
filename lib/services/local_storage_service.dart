import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyLastPromptTime = "last_update_prompt_time";
  static const _keySkippedVersion = "skipped_version";
  static const _keyForceShownOnce = "force_shown_once"; // 👈 new

  Future<void> saveLastPromptTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastPromptTime, time.millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastPromptTime() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_keyLastPromptTime);
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> saveSkippedVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySkippedVersion, version);
  }

  Future<String?> getSkippedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySkippedVersion);
  }

  Future<void> clearSkippedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySkippedVersion);
  }

  // 👇 NEW METHODS
  Future<void> setForceShownOnce(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyForceShownOnce, value);
  }

  Future<bool> isForceShownOnce() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyForceShownOnce) ?? false;
  }
}
