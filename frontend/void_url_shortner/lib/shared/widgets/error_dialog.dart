import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.deepSpace,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.errorRed.withValues(alpha: 0.3)),
      ),
      title: Row(
        children: [
          Icon(Icons.error_outline, color: AppTheme.errorRed, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.starlight,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(color: AppTheme.dimStar, fontSize: 14),
      ),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: Text('Retry', style: TextStyle(color: AppTheme.plasmaGreen)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK', style: TextStyle(color: AppTheme.plasmaGreen)),
        ),
      ],
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      builder:
          (context) =>
              ErrorDialog(title: title, message: message, onRetry: onRetry),
    );
  }
}
