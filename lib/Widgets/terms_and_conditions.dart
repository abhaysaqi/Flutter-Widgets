import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  final String prefixText;
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
  // 👇 Added so your Controller can track the value!
  final ValueChanged<bool>? onChanged; 

  const TermsAndConditions({
    super.key,
    this.prefixText = 'I agree to the ', // Fixed grammar
    this.termsText = 'Terms of Service',
    this.privacyText = 'Privacy Policy',
    this.activeColor = Colors.blue, // You can pass AppColors.primary here when calling it
    this.checkColor = Colors.white,
    this.textColor = Colors.black54,
    this.checkBoxSize = 24.0,
    this.fontSize = 14.0,
    this.spacing = 8.0,
    this.onTermsTap,
    this.onPrivacyTap,
    this.isChecked = false,
    this.onChanged,
  });

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  // Ensures the checkbox updates if the parent resets the form
  @override
  void didUpdateWidget(TermsAndConditions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      _isChecked = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // 👇 Aligns checkbox to the top if text wraps to a second line
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        SizedBox(
          height: 24, // Keeps the tap target standard
          width: 24,
          child: Transform.scale(
            scale: widget.checkBoxSize / 24,
            child: Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
                // 👇 Send the new value back to the parent screen
                if (widget.onChanged != null) {
                  widget.onChanged!(_isChecked);
                }
              },
              activeColor: widget.activeColor,
              checkColor: widget.checkColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              side: BorderSide(color: widget.textColor.withOpacity(0.5)),
            ),
          ),
        ),
        
        SizedBox(width: widget.spacing), // Uses your custom spacing
        
        Expanded( // 👇 Better text wrapping than Flexible
          child: RichText(
            text: TextSpan(
              text: widget.prefixText,
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize,
                height: 1.5, // Improves readability
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
                TextSpan(
                  text: ' and ',
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                  ),
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
      ],
    );
  }
}
