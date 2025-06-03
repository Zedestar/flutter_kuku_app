import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/graphql/graphql_queries.dart';
import 'package:kuku_app/widgets/app_bar.dart';
import 'package:kuku_app/widgets/post_card.dart';
import 'package:kuku_app/constants/constant.dart';

class GeneralPostDetailsView extends StatefulWidget {
  const GeneralPostDetailsView({super.key, required this.post});
  final dynamic post;

  @override
  State<GeneralPostDetailsView> createState() => _GeneralPostDetailsViewState();
}

class _GeneralPostDetailsViewState extends State<GeneralPostDetailsView> {
  final _commentInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, "Post Details"),
      body: PostCard(
        post: widget.post,
        commentsWidget: GraphQLConsumer(
          builder: (GraphQLClient client) {
            return FutureBuilder<QueryResult>(
              future: client.query(
                QueryOptions(
                  document: gql(commentsOfPostQuery),
                  variables: {
                    'id': int.parse(widget.post['id']),
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
        formWidget: Form(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _commentInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Comment cannot be empty";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Add comment',
                    hintText: 'Write comment here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  size: 30,
                  color: Colors.lightBlueAccent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
