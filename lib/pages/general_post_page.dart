import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';
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
        child: Column(
          children: [
            Text("General Post"),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcolor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/knowledge-post-page');
                    },
                    child: Text("Genearal Post"),
                  ),
                  Spacer(),
                  Text("Bussiness Post")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
