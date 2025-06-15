import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class VetInfoPage extends StatelessWidget {
  const VetInfoPage({super.key, required this.vetId, required this.vetName});

  final int vetId;
  final String vetName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, "Vet $vetName"),
      body: Center(
        child: Text("This is vet info page $vetId"),
      ),
    );
  }
}
