import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, 'help_and_supprt'),
      body: Center(
        child: Text(
          'Help & Support Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
