import 'package:flutter/material.dart';

class ProfileStatsBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const ProfileStatsBox({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}
