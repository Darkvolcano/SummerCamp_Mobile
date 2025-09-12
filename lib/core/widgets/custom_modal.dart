import 'package:flutter/material.dart';

class PlaceholderDialog extends StatelessWidget {
  const PlaceholderDialog({
    this.icon,
    required this.title,
    required this.message,
    required this.successText,
    required this.onSuccess,
    this.cancelText = "Cancel",
    this.onCancel,
    super.key,
  });

  final Widget? icon;
  final String? title;
  final String? message;

  /// Success button (bắt buộc)
  final String successText;
  final VoidCallback onSuccess;

  /// Cancel button (tùy chọn)
  final String cancelText;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      icon: icon,
      title: title == null ? null : Text(title!, textAlign: TextAlign.center),
      titleTextStyle: const TextStyle(color: Colors.black),
      content: message == null
          ? null
          : Text(message!, textAlign: TextAlign.center),
      contentTextStyle: const TextStyle(color: Colors.black),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowButtonSpacing: 8.0,
      actions: [
        // Cancel button (xám nhạt + hover / press hiệu ứng)
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.grey[300]!; // khi nhấn
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.grey[250]!; // khi hover
              }
              return Colors.grey[200]!; // mặc định
            }),
            foregroundColor: WidgetStateProperty.all(Colors.grey[800]),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            elevation: WidgetStateProperty.all(3),
            shadowColor: WidgetStateProperty.all(Colors.black45),
          ),
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        // Success button (primary + hover / press hiệu ứng)
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.pressed)) {
                return const Color(0xFF125FCC); // đậm hơn khi nhấn
              }
              if (states.contains(WidgetState.hovered)) {
                return const Color(0xFF3B8CFF); // sáng hơn khi hover
              }
              return const Color(0xFF1677FF); // mặc định
            }),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            elevation: WidgetStateProperty.all(4),
            shadowColor: WidgetStateProperty.all(Colors.black54),
          ),
          onPressed: onSuccess,
          child: Text(
            successText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
