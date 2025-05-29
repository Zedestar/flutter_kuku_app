import 'package:flutter/material.dart';

class TheButtomNavigationItem extends StatelessWidget {
  const TheButtomNavigationItem({
    super.key,
    required this.itemTitle,
    required this.itemIcon,
  });
  final String itemTitle;
  final IconData itemIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(itemIcon, size: 30, color: Colors.white70),
        Text(
          itemTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
