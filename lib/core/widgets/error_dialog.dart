import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';

class ErrorDialog {
  static Future<void> show(
    BuildContext context, {
    required String message,
    String title = 'Thông báo',
    String buttonText = 'Đóng',
    VoidCallback? onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 28),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.textStyleDefaultBold),
          ],
        ),
        content: Text(message, style: AppTextStyles.textContent2),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onClose?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(buttonText, style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
