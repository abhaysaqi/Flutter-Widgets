import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? logoImagePath;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final VoidCallback? onPressed;
  final double paddingHorizontal;
  final double paddingVertical;
  final double logoSize;
  final double fontSize;
  final double buttonHeight;
  final MainAxisAlignment alignment;
  final bool isButtonTakeFullWidth;

  const CustomButton({
    super.key,
    this.text = 'Continue with Facebook',
    this.icon,
    this.logoImagePath,
    this.backgroundColor = const Color(0xFF1877F2), // Default: Facebook blue
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.onPressed,
    this.paddingHorizontal = 16.0,
    this.paddingVertical = 12.0,
    this.logoSize = 24.0,
    this.fontSize = 16.0,
    this.alignment = MainAxisAlignment.center,
    this.isButtonTakeFullWidth = true,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isButtonTakeFullWidth ? double.infinity : null,
        child: ElevatedButton(
          onPressed: onPressed ?? () => debugPrint('Button Pressed!'),
          style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(buttonHeight),
              backgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: paddingVertical,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              elevation: 1,
              enableFeedback: true),
          child: Row(
            mainAxisSize:
                isButtonTakeFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: alignment,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: textColor,
                  size: logoSize,
                )
              else if (logoImagePath != null)
                Image.asset(
                  logoImagePath!,
                  width: logoSize,
                  height: logoSize,
                ),
              if (icon != null || logoImagePath != null)
                const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
