import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class TheRoomPage extends StatefulWidget {
  const TheRoomPage({super.key, required this.roomId});

  final int roomId;

  @override
  State<TheRoomPage> createState() => _TheRoomPageState();
}

class _TheRoomPageState extends State<TheRoomPage> {
  final _roomCommentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _roomCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, "Room"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            GraphQLConsumer(
              builder: (GraphQLClient client) {
                final options = WatchQueryOptions(
                  document: gql(r"""
              query($room_id:Int!){
                roomMessages(roomId:$room_id){
                  sender{
                    username
                    profilePick
                  }              
                  content
                  createdAt
                  }
              }"""),
                  variables: {'room_id': widget.roomId},
                  pollInterval: const Duration(seconds: 1),
                  fetchPolicy: FetchPolicy.cacheAndNetwork,
                  fetchResults: true,
                  parserFn: (data) => data,
                );

                final observableQuery = client.watchQuery(options);
                print(observableQuery);
                return StreamBuilder<QueryResult>(
                  stream: observableQuery.stream,
                  initialData: observableQuery.latestResult,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.data == null) {
                      return const Center(child: Text("No comments available"));
                    }

                    final comments = (snapshot.data!.data?['roomMessages']
                            as List<dynamic>?) ??
                        [];

                    if (comments.isEmpty) {
                      return const Center(child: Text("No comments available"));
                    }

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: comment['sender']
                                          ['profilePick'] !=
                                      null
                                  ? NetworkImage(
                                      comment['sender']['profilePick'])
                                  : AssetImage('assets/images/defaultPic.jpg')
                                      as ImageProvider,
                            ),
                            title: Text(comment['content']),
                            subtitle: Text(comment['sender']['username']),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _roomCommentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Comment cannot be empty";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Add comment',
                          hintText: 'Write comment here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    GraphQLConsumer(
                      builder: (GraphQLClient client) {
                        return IconButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              print("Ther is wrong with the form");
                              return;
                            }
                            MutationOptions options = MutationOptions(
                              document: gql(r"""
                                      mutation($room_id:Int!, $content:String!){
                                      createRoomMessage(roomId:$room_id, content:$content){
                                        successMessage
                                      }
                                    }
                                    """),
                              variables: {
                                "room_id": widget.roomId,
                                "content": _roomCommentController.text
                              },
                            );

                            final result = await client.mutate(options);
                            if (result.hasException) {
                              print(
                                  "Mutation failed: ${result.exception.toString()}");
                            } else {
                              final successMessage =
                                  result.data?['createRoomMessage']
                                      ?['successMessage'];
                              print("Success: $successMessage");
                              _roomCommentController
                                  .clear(); // optionally clear input
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.lightBlueAccent,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
