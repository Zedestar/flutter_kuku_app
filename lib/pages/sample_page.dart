import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, 'samples'),
      body: Center(
        child: Text("Thi is sample page"),
      ),
    );
  }
}
