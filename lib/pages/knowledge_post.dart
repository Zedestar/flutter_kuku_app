import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/graphql/graphql_queries.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class KnowledgePostPage extends StatefulWidget {
  const KnowledgePostPage({super.key});

  @override
  State<KnowledgePostPage> createState() => _KnowledgePostPageState();
}

class _KnowledgePostPageState extends State<KnowledgePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, "Knowledge Post"),
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
                    return ListTile(
                      title: Text(post['title'] ?? 'No Title'),
                      subtitle: Text(post['caption'] ?? 'No Caption'),
                      leading: post['pictureUrl'] != null
                          ? Image.network(
                              post['pictureUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : null,
                      trailing: Text(
                        "Posted by ${post['user']['username']} on ${post['createdAt']}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
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
