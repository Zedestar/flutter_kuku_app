import 'package:flutter/material.dart';

class GeneralPostPage extends StatefulWidget {
  const GeneralPostPage({super.key});

  @override
  State<GeneralPostPage> createState() => _GeneralPostPageState();
}

class _GeneralPostPageState extends State<GeneralPostPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("The general post page"),
    );
  }
}
