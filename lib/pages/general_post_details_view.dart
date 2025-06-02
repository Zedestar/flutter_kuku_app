import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/graphql/graphql_queries.dart';
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
      body: PostCard(
        post: post,
        commentsWidget: GraphQLConsumer(
          builder: (GraphQLClient client) {
            return FutureBuilder<QueryResult>(
              future: client.query(
                QueryOptions(
                  document: gql(commentsOfPostQuery),
                  variables: {
                    'id': int.parse(post['id']),
                  },
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  final comments =
                      snapshot.data?.data?['comments'] as List<dynamic> ?? [];

                  if (comments.isEmpty) {
                    return const Center(
                      child: Text("No comments available"),
                    );
                  }
                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 16,
                          ),
                          title: Text(comment['body']),
                          subtitle: Text(comment['user']['username']),
                        );
                      },
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
