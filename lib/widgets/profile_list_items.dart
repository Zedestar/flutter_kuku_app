import 'package:flutter/material.dart';

class ProfileListItems extends StatelessWidget {
  const ProfileListItems(
      {super.key,
      required this.icon,
      required this.text,
      required this.theActionOnTap});
  final IconData icon;
  final String text;
  final VoidCallback theActionOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          icon,
        ),
        title: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: theActionOnTap);
  }
}
