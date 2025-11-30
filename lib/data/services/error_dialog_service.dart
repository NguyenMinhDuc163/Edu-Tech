import 'package:flutter/material.dart';
import '../../core/public/navigation_service.dart';

class ErrorDialogService {
  ErrorDialogService._();

  static void showError(String message) {
    final context = NavigationService.navigatorKey.currentContext;

    if (context == null) {
      debugPrint('ErrorDialogService: context is null');
      debugPrint('Error message: $message');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text('Cảnh báo'),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Đóng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        );
      },
    );
  }
}
