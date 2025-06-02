import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, required this.commentsWidget});

  final dynamic post;
  final Widget commentsWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: post['pictureUrl'] != null
                      ? Image.network(
                          post['pictureUrl'],
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['title'] ?? 'No Title',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        post['caption'] ?? 'No no Caption',
                        style: const TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          CircleAvatar(),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            post['user']['username'] ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 2, // left padding
                        endIndent: 16, // right padding
                      ),
                      SizedBox(child: commentsWidget),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  // Handle like action
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  // Handle comment action
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Handle share action
                },
              ),
            ],
          )
        ],
      ),
    );
    ;
  }
}
