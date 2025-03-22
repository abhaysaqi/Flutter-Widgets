import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  final String termsText;
  final String privacyText;
  final Color activeColor;
  final Color checkColor;
  final Color textColor;
  final double checkBoxSize;
  final double fontSize;
  final double spacing;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final bool isChecked;

  const TermsAndConditions({
    super.key,
    this.termsText = 'Terms of Service',
    this.privacyText = 'Privacy Policy',
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.textColor = Colors.black54,
    this.checkBoxSize = 24.0,
    this.fontSize = 14.0,
    this.spacing = 8.0,
    this.onTermsTap,
    this.onPrivacyTap,
    this.isChecked = false,
  });

  @override
  State<TermsAndConditions> createState() => _CustomCheckBoxWithTextState();
}

class _CustomCheckBoxWithTextState extends State<TermsAndConditions> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.red,
            child: Transform.scale(
              scale: widget.checkBoxSize / 24,
              // scale: widget.checkBoxSize / 24.0,
              child: Checkbox(
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
                activeColor: widget.activeColor,
                checkColor: widget.checkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              color: Colors.amber,
              child: RichText(
                text: TextSpan(
                  text: "I'm agree to the ",
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                  ),
                  children: [
                    TextSpan(
                      text: widget.termsText,
                      style: TextStyle(
                        color: widget.activeColor,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onTermsTap ??
                            () {
                              debugPrint('Terms of Service tapped');
                            },
                    ),
                    const TextSpan(
                      text: ' and ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextSpan(
                      text: widget.privacyText,
                      style: TextStyle(
                        color: widget.activeColor,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onPrivacyTap ??
                            () {
                              debugPrint('Privacy Policy tapped');
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
