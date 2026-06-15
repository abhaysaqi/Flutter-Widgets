import 'package:flutter/material.dart';

class CustomDrawerItem extends StatelessWidget {
  final CustomDrawerItemModel item;
  final bool isSelected;
  final Color? selectedColor;

  const CustomDrawerItem({
    super.key,
    required this.item,
    this.isSelected = false,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: item.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            padding: item.padding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isSelected
                  ? (selectedColor ??
                      Theme.of(context)
                          .primaryColor
                          .withOpacity(0.12))
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                item.leading ??
                    Icon(
                      item.icon,
                      color: item.iconColor ??
                          Theme.of(context).primaryColor,
                    ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    item.title,
                    style: item.textStyle ??
                        TextStyle(
                          color: item.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),

                item.trailing ??
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
              ],
            ),
          ),
        ),

        if (item.showDivider)
          const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}
