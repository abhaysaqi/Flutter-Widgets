import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomSignInSignUpText extends StatelessWidget {
  final String haveAccountOrNotText;
  final String signinOrSingupText;
  final Color textColor;
  final Color linkColor;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onTap;
  final double spacing;
  final bool showSignIn;

  const CustomSignInSignUpText({
    super.key,
    required this.haveAccountOrNotText,
    this.textColor = Colors.black54,
    this.linkColor = Colors.blue,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w400,
    this.onTap,
    this.spacing = 4.0,
    this.showSignIn = true,
    required this.signinOrSingupText,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: haveAccountOrNotText,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        children: [
          TextSpan(
              text: signinOrSingupText,
              style: TextStyle(
                color: linkColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = onTap ?? () => debugPrint("Tapped Work")),
        ],
      ),
    );
  }
}
