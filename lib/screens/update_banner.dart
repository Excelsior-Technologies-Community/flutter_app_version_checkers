import 'package:flutter/material.dart';

class UpdateBanner extends StatelessWidget {
  final String message;
  final VoidCallback onUpdate;
  final VoidCallback onLater;

  const UpdateBanner({
    super.key,
    required this.message,
    required this.onUpdate,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.system_update, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            TextButton(onPressed: onLater, child: const Text("Later")),
            ElevatedButton(onPressed: onUpdate, child: const Text("Update")),
          ],
        ),
      ),
    );
  }
}
