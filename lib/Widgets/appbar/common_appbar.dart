import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leadingIcon;
  final Widget? actionIcon;
  final Color backgroundColor;
  final double elevation;
  final Color iconColor;
  final TextStyle? titleTextStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.actionIcon,
    this.backgroundColor = Colors.white,
    this.elevation = 4.0,
    this.iconColor = Colors.black,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: true,
      leading: leadingIcon ??
          IconButton(
            icon: Icon(Icons.arrow_back, color: iconColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
      title: Text(
        title,
        style: titleTextStyle ??
            TextStyle(
              color: iconColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        actionIcon ??
            IconButton(
              icon: Icon(Icons.search, color: iconColor),
              onPressed: () {
                debugPrint('Search icon tapped');
              },
            ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
