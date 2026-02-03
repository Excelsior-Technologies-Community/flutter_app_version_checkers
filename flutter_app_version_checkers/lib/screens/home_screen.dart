import 'package:flutter/material.dart';
import 'package:flutter_app_version_checkers/screens/update_banner.dart';
import 'package:flutter_app_version_checkers/screens/update_dialog.dart';
import '../services/version_service.dart';
import '../services/local_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// 👇 IMPORTANT: WidgetsBindingObserver add kiya
class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _versionService = VersionService();
  final _storage = LocalStorageService();

  bool _showBanner = false;
  bool _waitingForStoreReturn = false;

  String _bannerMessage = "";
  String _storeUrl = "";
  String _latestVersion = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // ✅ lifecycle listen
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVersion());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ✅ cleanup
    super.dispose();
  }

  // ✅ Play Store se wapas aane par yaha trigger hoga
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("🔄 Lifecycle: $state");

    if (state == AppLifecycleState.resumed && _waitingForStoreReturn) {
      debugPrint("🔥 Returned from Play Store → Show SOFT update");

      setState(() {
        _showBanner = true;
      });

      _waitingForStoreReturn = false; // reset flag
    }
  }

  Future<void> _checkVersion() async {
    final currentVersion = await _versionService.getCurrentVersion();
    final info = await _versionService.fetchLatestVersionInfo();

    if (info == null) return;

    final hasUpdate =
    _versionService.isUpdateAvailable(currentVersion, info.latestVersion);
    if (!hasUpdate) return;

    final storeUrl = _versionService.getStoreUrl(info);

    final force =
    _versionService.isForceUpdate(currentVersion, info.minSupportedVersion);

    final forceShownOnce = await _storage.isForceShownOnce();

    debugPrint("Current: $currentVersion");
    debugPrint("MinSupported: ${info.minSupportedVersion}");
    debugPrint("Latest: ${info.latestVersion}");
    debugPrint("Force: $force");
    debugPrint("ForceShownOnce: $forceShownOnce");

    // 🧠 CASE 1: Force update AND not shown before → show FORCE dialog
    if (force && !forceShownOnce && mounted) {
      await _storage.setForceShownOnce(true); // mark as shown

      await UpdateDialog.show(
        context,
        forceUpdate: true,
        message: info.message,
        storeUrl: storeUrl,
        onUpdatePressed: () async {
          debugPrint("➡️ Going to Play Store");

          // user is going to store now
          _waitingForStoreReturn = true;

          // prepare data for soft update banner
          _bannerMessage = info.message;
          _storeUrl = storeUrl;
          _latestVersion = info.latestVersion;
        },
      );
      return;
    }

    // 🧠 CASE 2: Soft update flow

    // Skip logic
    final skipped = await _storage.getSkippedVersion();
    if (skipped == info.latestVersion) return;

    // Cooldown: 24 hours
    final lastPrompt = await _storage.getLastPromptTime();
    if (lastPrompt != null &&
        DateTime.now().difference(lastPrompt).inHours < 24) {
      return;
    }

    // ✅ Show soft update banner
    setState(() {
      _showBanner = true;
      _bannerMessage = info.message;
      _storeUrl = storeUrl;
      _latestVersion = info.latestVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Advanced Version Checker")),
      body: Column(
        children: [
          if (_showBanner)
            UpdateBanner(
              message: _bannerMessage,
              onLater: () async {
                await _storage.saveLastPromptTime(DateTime.now());
                setState(() => _showBanner = false);
              },
              onUpdate: () async {
                await UpdateDialog.show(
                  context,
                  forceUpdate: false,
                  message: _bannerMessage,
                  storeUrl: _storeUrl,
                  onUpdatePressed: () async {
                    debugPrint("➡️ Soft update: Going to Play Store");
                  },
                );
              },
            ),
          const Expanded(
            child: Center(
              child: Text(
                "Advanced App Version Checker Demo",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
