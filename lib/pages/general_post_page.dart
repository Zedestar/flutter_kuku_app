import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class GeneralPostPage extends StatefulWidget {
  const GeneralPostPage({super.key});

  @override
  State<GeneralPostPage> createState() => _GeneralPostPageState();
}

class _GeneralPostPageState extends State<GeneralPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, "Post_page"),
      body: Center(
        child: Text("The general post page"),
      ),
    );
  }
}
