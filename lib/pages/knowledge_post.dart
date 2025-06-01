import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/graphql/graphql_queries.dart';

class KnowledgePostPage extends StatefulWidget {
  const KnowledgePostPage({super.key});

  @override
  State<KnowledgePostPage> createState() => _KnowledgePostPageState();
}

class _KnowledgePostPageState extends State<KnowledgePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          return FutureBuilder<QueryResult>(
            future: client.query(
              QueryOptions(
                document: gql(generalPostQuery),
              ),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Shapshot error ${snapshot.error}"),
                );
              } else {
                final posts =
                    snapshot.data?.data?['posts'] as List<dynamic> ?? [];
                if (posts.isEmpty) {
                  return const Center(
                    child: Text("No posts available"),
                  );
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    print("THis is image url${post['pictureUrl']}");

                    return GFCard(
                      boxFit: BoxFit.cover,
                      image: Image.network(
                        "https://media.istockphoto.com/id/1140829787/photo/sunset-at-savannah-plains.jpg?s=1024x1024&w=is&k=20&c=7Eraf7pY9AT-okf8710mu1etFEyOBOlrRK6vLfFo0s4=",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      title: GFListTile(
                        title: Text(
                          post['title'] ?? 'No Title',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(
                              width: 5,
                            ),
                            const CircleAvatar(
                              radius: 16,
                              // backgroundImage:
                              // AssetImage('assets/images/user.png'),
                            )
                          ],
                        ),
                        subTitle: Text(
                          post['caption'] ?? 'No Caption',
                          style: const TextStyle(fontSize: 14),
                        ),
                        description: Text(
                          "Posted by ${post['user']['username']} on ${post['createdAt']}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                    // ListTile(
                    //   title: Text(post['title'] ?? 'No Title'),
                    //   subtitle: Text(post['caption'] ?? 'No Caption'),
                    //   leading: post['pictureUrl'] != null
                    //       ? Image.network(
                    //           post['pictureUrl'],
                    //           width: 50,
                    //           height: 50,
                    //           fit: BoxFit.cover,
                    //         )
                    //       : null,
                    //   trailing: Text(
                    //     "Posted by ${post['user']['username']} on ${post['createdAt']}",
                    //     style: const TextStyle(fontSize: 12),
                    //   ),
                    // );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
