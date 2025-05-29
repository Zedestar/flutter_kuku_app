import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: Center(
        child: Text(
          'Help & Support Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
