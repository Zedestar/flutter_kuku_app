import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';

class BottomSheetTiles extends StatelessWidget {
  const BottomSheetTiles(
      {super.key,
      required this.tileString,
      required this.tileIcon,
      required this.theFunction});

  final String tileString;
  final IconData tileIcon;
  final VoidCallback theFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        tileIcon,
        color: kcolor,
      ),
      title: Text(
        tileString,
        style: TextStyle(color: kcolor, fontWeight: FontWeight.w400),
      ),
      onTap: theFunction,
    );
  }
}
