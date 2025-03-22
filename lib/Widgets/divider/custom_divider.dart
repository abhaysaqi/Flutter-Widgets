import 'package:flutter/material.dart';

class CustomDividerWithText extends StatelessWidget {
  final String text;
  final Color lineColor;
  final double lineThickness;
  final double spacing;
  final TextStyle? textStyle;
  final double paddingHorizontal;
  final double paddingVertical;

  const CustomDividerWithText({
    super.key,
    this.text = 'Or',
    this.lineColor = Colors.grey,
    this.lineThickness = 0.5,
    this.spacing = 8.0,
    this.textStyle,
    this.paddingHorizontal = 0.0,
    this.paddingVertical = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: spacing),
              height: lineThickness,
              color: lineColor,
            ),
          ),
          Text(
            text,
            style: textStyle ??
                const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: spacing),
              height: lineThickness,
              color: lineColor,
            ),
          ),
        ],
      ),
    );
  }
}
