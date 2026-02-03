class AppVersionInfo {
  final String latestVersion;
  final String minSupportedVersion;
  final String androidUrl;
  final String iosUrl;
  final String message;

  AppVersionInfo({
    required this.latestVersion,
    required this.minSupportedVersion,
    required this.androidUrl,
    required this.iosUrl,
    required this.message,
  });
}
