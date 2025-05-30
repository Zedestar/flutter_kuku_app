import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class GeneralChatPage extends StatefulWidget {
  const GeneralChatPage({super.key});

  @override
  State<GeneralChatPage> createState() => _GeneralChatPageState();
}

class _GeneralChatPageState extends State<GeneralChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, 'chat_page'),
      body: const Center(
        child: Text("This is the general chat page"),
      ),
    );
  }
}
