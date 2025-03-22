import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? fillColor;
  final double borderRadius;
  final double contentPadding;
  final bool isPassword;
  final bool isEnabled;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final BorderSide? focusedBorderSide;
  final Function(String)? onChanged;
  final Function()? onTapSuffixIcon;
  final Function()? onTapPrefixIcon;

   CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderRadius = 8.0,
    this.contentPadding = 16.0,
    this.isPassword = false,
    this.isEnabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.onTapSuffixIcon,
    this.onTapPrefixIcon,
    this.textInputAction,
    this.keyboardType,
    this.focusedBorderSide,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType ?? TextInputType.text,
      controller: controller,
      obscureText: isPassword,
      enabled: isEnabled,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText ?? 'Enter text...',
        labelText: labelText,
        hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
        labelStyle: labelStyle ?? const TextStyle(color: Colors.black),
        filled: true,
        
        fillColor: fillColor ?? Colors.grey.shade200,
        contentPadding: EdgeInsets.all(contentPadding),
        prefixIcon: prefixIcon != null
            ? GestureDetector(
                onTap: onTapPrefixIcon,
                child:  Icon(prefixIcon, color: Colors.grey),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onTapSuffixIcon,
                child: Icon(suffixIcon, color: Colors.grey),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide:
              focusedBorderSide ?? BorderSide(color: Colors.blue, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
