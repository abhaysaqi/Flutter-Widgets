import 'package:flutter/material.dart';

class CustomDrawerItemModel {
  final IconData? icon;
  final Widget? leading;

  final String title;
  final Widget? trailing;

  final VoidCallback onTap;

  final Color? iconColor;
  final Color? textColor;
  final TextStyle? textStyle;

  final bool showDivider;
  final EdgeInsetsGeometry? padding;

  const CustomDrawerItemModel({
    this.icon,
    this.leading,
    required this.title,
    this.trailing,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.textStyle,
    this.showDivider = false,
    this.padding,
  });
}
