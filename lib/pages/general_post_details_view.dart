import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/post_card.dart';

class GeneralPostDetailsView extends StatelessWidget {
  const GeneralPostDetailsView({super.key, required this.post});
  final dynamic post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: SizedBox(
        child: Column(
          children: [PostCard(post: post)],
        ),
      ),
    );
  }
}
