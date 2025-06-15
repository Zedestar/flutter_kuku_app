import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class PrivateRoomPage extends StatefulWidget {
  const PrivateRoomPage({super.key, required this.roomId});

  final int roomId;

  @override
  State<PrivateRoomPage> createState() => _PrivateRoomPageState();
}

class _PrivateRoomPageState extends State<PrivateRoomPage> {
  final _roomMessageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _roomMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, "Chatroom vet ${widget.roomId}"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            GraphQLConsumer(
              builder: (GraphQLClient client) {
                final options = WatchQueryOptions(
                  document: gql(r"""
     query($roomId:Int!){
  myChatmatesMessage(roomId:$roomId){
    id
    content
    sender{
      username
      profilePick
    }
  }
}

"""),
                  variables: {'roomId': widget.roomId},
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

                    final comments = (snapshot.data!.data?['myChatmatesMessage']
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
                          final message = comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: message['sender']
                                          ['profilePick'] !=
                                      null
                                  ? NetworkImage(
                                      message['sender']['profilePick'])
                                  : AssetImage('assets/images/defaultPic.jpg')
                                      as ImageProvider,
                            ),
                            title: Text(message['content']),
                            subtitle: Text(message['sender']['username']),
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
                        controller: _roomMessageController,
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
                                     mutation($roomId:Int!, $content:String!){
                                        createDirectRoomMessage(roomId: $roomId, content:$content){
                                        successMessage
                                      }
                                     }
                                    """),
                              variables: {
                                "roomId": widget.roomId,
                                "content": _roomMessageController.text
                              },
                            );

                            final result = await client.mutate(options);
                            if (result.hasException) {
                              print(
                                  "Mutation failed: ${result.exception.toString()}");
                            } else {
                              final successMessage =
                                  result.data?['createDirectRoomMessage']
                                      ?['successMessage'];
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Success"),
                                    content: Text(successMessage),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Closes the dialog
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              _roomMessageController
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
