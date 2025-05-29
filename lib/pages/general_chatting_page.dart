import 'package:flutter/material.dart';

class GeneralChatPage extends StatefulWidget {
  const GeneralChatPage({super.key});

  @override
  State<GeneralChatPage> createState() => _GeneralChatPageState();
}

class _GeneralChatPageState extends State<GeneralChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("This is the general chat page"),
    );
  }
}
