import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/app_version_info.dart';

class VersionService {
  Future<String> getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<AppVersionInfo?> fetchLatestVersionInfo() async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // mock API delay

      // Mock API response
      return AppVersionInfo(
        latestVersion: "1.2.0",
        minSupportedVersion: "1.1.0", // <= current version
        androidUrl: "https://play.google.com/store/apps/details?id=com.example.app",
        iosUrl: "https://apps.apple.com/app/id000000000",
        message: "New version available with improvements.",
      );

    } catch (e) {
      // API failed
      return null;
    }
  }

  int compareVersions(String v1, String v2) {
    final v1Parts = v1.split('.').map(int.parse).toList();
    final v2Parts = v2.split('.').map(int.parse).toList();
    final maxLen = v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

    for (int i = 0; i < maxLen; i++) {
      final p1 = i < v1Parts.length ? v1Parts[i] : 0;
      final p2 = i < v2Parts.length ? v2Parts[i] : 0;
      if (p1 > p2) return 1;
      if (p1 < p2) return -1;
    }
    return 0;
  }

  bool isUpdateAvailable(String current, String latest) {
    return compareVersions(current, latest) < 0;
  }

  bool isForceUpdate(String current, String minSupported) {
    return compareVersions(current, minSupported) < 0;
  }

  String getStoreUrl(AppVersionInfo info) {
    if (Platform.isIOS) return info.iosUrl;
    return info.androidUrl;
  }
}
