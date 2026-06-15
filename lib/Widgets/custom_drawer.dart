import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Widget? header;
  final List<CustomDrawerItemModel> items;

  const CustomDrawer({
    super.key,
    this.header,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            header ?? const SizedBox(),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  return CustomDrawerItem(
                    item: items[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
