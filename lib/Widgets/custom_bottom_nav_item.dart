import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String? label;

  final Color? activeColor;
  final Color? inactiveColor;

  final Widget? badge;
  final Widget? customIcon;

  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;

  const BottomNavItem({
    required this.icon,
    this.selectedIcon,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.badge,
    this.customIcon,
    this.labelStyle,
    this.padding,
  });
}
