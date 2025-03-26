import 'package:flutter/material.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String yesButtonText;
  final String noButtonText;
  final Color? titleColor;
  final Color? messageColor;
  final Color? yesButtonColor;
  final Color? noButtonColor;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final IconData? icon;
  final Color? iconColor;
  final double borderRadius;

  const CustomConfirmDialog({
    super.key,
    this.title = 'Are you sure?',
    this.message = 'Do you really want to proceed?',
    this.yesButtonText = 'Yes',
    this.noButtonText = 'No',
    required this.onYes,
    required this.onNo,
    this.titleColor,
    this.messageColor,
    this.yesButtonColor,
    this.noButtonColor,
    this.icon,
    this.iconColor,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 48,
                color: iconColor ?? Colors.blue,
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: titleColor ?? Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: messageColor ?? Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // No Button
                ElevatedButton(
                  onPressed: onNo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: noButtonColor ?? Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    noButtonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Yes Button
                ElevatedButton(
                  onPressed: onYes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yesButtonColor ?? Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    yesButtonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
