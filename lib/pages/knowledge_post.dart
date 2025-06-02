import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/constants/constant.dart';
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
                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    height: 200,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: kcolor),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/generalPostDetailsView',
                                            arguments: post);
                                      },
                                      child: Text("View"),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kcolor,
        onPressed: null,
        child: Text(
          "Create Post",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
