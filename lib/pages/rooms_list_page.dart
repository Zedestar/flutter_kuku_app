import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          final WatchQueryOptions options = WatchQueryOptions(
            document: gql(
              """
                query{
                  roomList{
                    id
                    host{
                      username
                      profilePick
                    }
                   
                    description
                    participants{
                      username
                    }
                    createdAt
                  }
                }                               
                """,
            ),
            // pollInterval: Duration(seconds: 10),
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
                    child: Text("Login to get your samples"),
                  );
                }
              }

              final data = snapshot.data!.data;
              final rooms = data?['roomList'];

              if (rooms != null && rooms is List && rooms.isNotEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 4,
                    )),
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/the_room',
                                  arguments: int.parse(rooms[index]['id']));
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Time taken
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: rooms[index]['host']
                                                    ['profilePick'] !=
                                                null
                                            ? NetworkImage(rooms[index]['host']
                                                ['profilePick'])
                                            : AssetImage(
                                                    'assets/images/defaultPic.jpg')
                                                as ImageProvider,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        rooms[index]['host']['username'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: 4),

                                  Divider(),

                                  SizedBox(width: 4),
                                  Text(
                                    rooms[index]['description'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: rooms.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 1),
                    ),
                  ],
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
