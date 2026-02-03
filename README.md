# FlutterAppVersionCheckers

A simple yet advanced Flutter App Version Checker example project that demonstrates:
- ✅ Force Update Dialog
- ✅ Soft Update Banner
- ✅ Play Store se wapas aane par automatic Soft Update show
- ✅ Skip & Cooldown logic
- ✅ Local storage using shared_preferences
- ✅ App lifecycle handling (resume detection)

This project is built as a normal Flutter app (not a package), but the structure is future-ready to convert into a reusable library.

---
## ✨ Preview

![screen-20260203-1714533](https://github.com/user-attachments/assets/b6e29c81-17be-43ba-8181-df62547b5a59)

---
## ✨ Installation
Add this to your package's pubspec.yaml file:
```
dependencies:
  flutter_app_version_checkers:
    path: ../flutter_app_version_checkers  # For local development
```
from git:
```
dependencies:
  flutter_app_version_checkers:
    git:
      url: https://github.com/yourusername/flutter_app_version_checkers.git  # Your github path
``` 
Then run:
```
flutter pub get
```
---
## ✨ Features
#### 🔒 Force Update
 - User cannot dismiss the dialog
 - Back button disabled
 - Must press Update to continue

#### 🟡 Soft Update
 - Shows a top banner
 - User can choose Later or Update

#### 🔁 Smart Flow
 - First time → Force Update dialog
 - User goes to Play Store and comes back → Soft Update banner appears

#### ⏳ Cooldown Support
 - If user taps “Later”, banner won’t show again for 24 hours

#### ⏭️ Skip Version Support
 - User can skip a specific version (soft update)

---
## 📁 Project Structure
   ```
   lib/
 ├── main.dart
 ├── screens/
 │    ├── home_screen.dart
 │    ├── update_dialog.dart
 │    └── update_banner.dart
 ├── services/
 │    ├── version_service.dart
 │    └── local_storage_service.dart
 └── models/
      └── version_info.dart
```
---
## 📦 Dependencies
In pubspec.yaml:
```
dependencies:
  flutter:
    sdk: flutter
  package_info_plus: ^9.0.0
  url_launcher: ^6.3.2
  shared_preferences: ^2.5.3

```
---
## 🧠 How It Works
1. App starts → HomeScreen calls _checkVersion()
   
3. App gets:
  - Current version (from package_info_plus)
  - Latest version info (from VersionService)
   
3. Logic:
  - If current < minSupportedVersion → 🔒 Force Update dialog
  - Else if current < latestVersion → 🟡 Soft Update banner
   
4. When user clicks Update:
  - Play Store opens
  - Dialog closes

5. When user comes back from Play Store:
  - App detects AppLifecycleState.resumed
  - Shows Soft Update banner
 ---
## 🧪 Test Flow (Recommended)
1. Fully stop the app
2. Run app again
3. You should see:
   - ✅ Force Update dialog first
4. Tap Update → Play Store opens
5. Press Back → App resumes
6. You should now see: 
   - ✅ Soft Update banner on top

---
## 🧩 API Overview (Core Classes)
### VersionService
##### Responsible for:
  - Getting current app version
  - Fetching latest version info (API / mock / Firebase, etc.)
  - Comparing versions
  - Deciding force vs soft update
##### Example methods:
```
Future<String> getCurrentVersion();
Future<VersionInfo?> fetchLatestVersionInfo();
bool isUpdateAvailable(String current, String latest);
bool isForceUpdate(String current, String minSupported);
String getStoreUrl(VersionInfo info);

```
### LocalStorageService
##### Handles local persistence:
 - Skip version
 - Last prompt time (cooldown)
 - Force dialog shown flag
##### Example methods:
```
Future<void> saveSkippedVersion(String version);
Future<String?> getSkippedVersion();

Future<void> saveLastPromptTime(DateTime time);
Future<DateTime?> getLastPromptTime();

Future<void> setForceShownOnce(bool value);
Future<bool> isForceShownOnce();

```
### UpdateDialog
##### Shows:
 - 🔒 Force update dialog (non-dismissible)
 - 🟡 Soft update dialog (dismissible)
##### Usage:
```
await UpdateDialog.show(
  context,
  forceUpdate: true,
  message: "Please update the app",
  storeUrl: "https://play.google.com/...",
  onUpdatePressed: () {
    // handle update click
  },
);

```
### UpdateBanner
Top banner for soft updates with:
- Later
- Update
##### Usage:
```
UpdateBanner(
  message: "New version available!",
  onLater: () {},
  onUpdate: () {},
)
```
---
## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```
---
