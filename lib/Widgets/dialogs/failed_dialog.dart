import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FailedDialog extends StatelessWidget {
  final String title;
  final String message;
  final String lottieAsset;
  final VoidCallback onRetry;
  final String buttonText;
  final Color? buttonColor;

  const FailedDialog({
    super.key,
    this.title = 'Oops!',
    this.message = 'Something went wrong. Please try again.',
    this.lottieAsset = 'assets/lotties/failed.json',
    required this.onRetry,
    this.buttonText = 'Retry',
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              lottieAsset,
              width: 250,
              height: 200,
              fit: BoxFit.cover,
              repeat: true,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? Colors.pink[400],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
