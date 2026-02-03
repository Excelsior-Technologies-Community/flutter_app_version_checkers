import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog {
  static Future<void> show(
      BuildContext context, {
        required bool forceUpdate,
        required String message,
        required String storeUrl,
        VoidCallback? onUpdatePressed,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (dialogContext) {
        return WillPopScope(
          onWillPop: () async => !forceUpdate,
          child: AlertDialog(
            title: const Text("Update Available 🚀"),
            content: Text(message),
            actions: [
              if (!forceUpdate)
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("Later"),
                ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();

                  onUpdatePressed?.call();

                  final uri = Uri.parse(storeUrl);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: const Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }
}
