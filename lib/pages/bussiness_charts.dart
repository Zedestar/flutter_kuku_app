import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BussinessChats extends StatefulWidget {
  const BussinessChats({super.key});

  @override
  State<BussinessChats> createState() => _BussinessChatsState();
}

class _BussinessChatsState extends State<BussinessChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          final WatchQueryOptions options = WatchQueryOptions(
            document: gql(
              """
                query {
                bussinessRooms {
                  id
                  sender {
                    id
                    username
                    profilePick
                  }
                  reciver {
                    id
                    username
                    profilePick
                  }
                }
}

                """,
            ),
            // pollInterval: Duration(seconds: 10),
            fetchPolicy: FetchPolicy.networkOnly,
            fetchResults: true,
          );
          final ObservableQuery observableQuery = client.watchQuery(options);
          observableQuery.fetchResults();

          return StreamBuilder<QueryResult>(
            stream: observableQuery.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                final theError = snapshot.error.toString();
                if (theError.contains('SocketException')) {
                  return Center(
                    child: Text("There is no internent connection"),
                  );
                } else {
                  return Center(
                    child: Text("Error occured $theError"),
                  );
                }
              }
              if (snapshot.data!.hasException) {
                final graphQLError = snapshot.data!.exception;
                if (graphQLError != null) {
                  if (graphQLError.linkException is LinkException) {
                    return Center(
                      child: Text("The server is temporary unvailable"),
                    );
                  }
                  return Center(
                    // child: Text(
                    //     'GraphQL error: ${graphQLError.graphqlErrors.join(", ")}')
                    child: Text("Login to access bussines chats room"),
                  );
                }
              }

              final data = snapshot.data!.data;
              final rooms = data?['bussinessRooms'];

              if (rooms != null && rooms is List && rooms.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: 4,
                      )),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: rooms.length,
                          (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/private-bussines-room',
                                  arguments: int.parse(rooms[index]['id']),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: rooms[index]
                                                                ['sender']
                                                            ['profilePick'] !=
                                                        null
                                                    ? NetworkImage(rooms[index]
                                                            ['sender']
                                                        ['profilePick'])
                                                    : AssetImage(
                                                            'assets/images/defaultPic.jpg')
                                                        as ImageProvider,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                rooms[index]['sender']
                                                    ['username'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: rooms[index]
                                                                ['reciver']
                                                            ['profilePick'] !=
                                                        null
                                                    ? NetworkImage(rooms[index]
                                                            ['reciver']
                                                        ['profilePick'])
                                                    : AssetImage(
                                                            'assets/images/defaultPic.jpg')
                                                        as ImageProvider,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                rooms[index]['reciver']
                                                    ['username'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      // Text(
                                      //   rooms[index]['sender']['email'],
                                      //   style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w600),
                                      // ),
                                      SizedBox(width: 4),
                                      Divider(),
                                      SizedBox(
                                        width: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "No room created yet",
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
