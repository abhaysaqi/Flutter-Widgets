import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String? iconPath;      // For image assets (e.g., 'assets/google.png')
  final IconData? iconData;    // For Flutter Icons (e.g., Icons.apple)
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;      // Custom color specifically for IconData if needed
  final double height;
  final double borderRadius;

  const SocialButton({
    super.key,
    this.iconPath,
    this.iconData,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.primary,
    this.textColor = AppColors.primaryText,
    this.iconColor,
    this.height = 54.0,
    this.borderRadius = 14.0,
  }) : assert(
          (iconPath != null && iconData == null) || (iconPath == null && iconData != null),
          'You must provide either an iconPath or iconData, but not both.',
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: borderColor!,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dynamically render either the Image Asset or the IconData
            if (iconPath != null)
              Image.asset(
                iconPath!,
                width: 22,
                height: 22,
              )
            else if (iconData != null)
              Icon(
                iconData,
                size: 22,
                color: iconColor ?? textColor, // Defaults to text color if not specified
              ),

            const SizedBox(width: 10),
            
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
