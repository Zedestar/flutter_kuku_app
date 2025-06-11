import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({super.key});

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: GraphQLConsumer(
          builder: (GraphQLClient client) {
            final WatchQueryOptions options = WatchQueryOptions(
              document: gql(
                """
                query{
                    users{
                      id
                      username
                      firstName
                      lastName
                      email
                      profilePick
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
                final doctors = data?['users'];

                if (doctors != null && doctors is List && doctors.isNotEmpty) {
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
                            childCount: doctors.length,
                            (context, index) {
                              return Card(
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
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: doctors[index]
                                                    ['profilePick'] !=
                                                null
                                            ? NetworkImage(
                                                doctors[index]['username'])
                                            : AssetImage(
                                                    'assets/images/defaultPic.jpg')
                                                as ImageProvider,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        doctors[index]['username'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        doctors[index]['email'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(width: 4),
                                      Divider(),
                                      SizedBox(
                                        width: 4,
                                      ),
                                    ],
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
      ),
    );
  }
}
