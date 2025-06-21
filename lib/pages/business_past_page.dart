import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants/constant.dart';

class BussinessPage extends StatefulWidget {
  const BussinessPage({super.key});

  @override
  State<BussinessPage> createState() => _BussinessPageState();
}

class _BussinessPageState extends State<BussinessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          return FutureBuilder<QueryResult>(
            future: client.query(
              QueryOptions(
                document: gql(r"""
                    query{
                      marketPosts{
                        user{
                          id
                          username,
                          profilePick
                        }
                        marketPic
                        productName
                        price
                        description
                      }
                    }

                """),
                fetchPolicy: FetchPolicy.networkOnly,
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
                } else {
                  return Center(
                    child: Text("There is an error, related to the server"),
                  );
                }
              } else {
                final posts =
                    snapshot.data?.data?['marketPosts'] as List<dynamic> ?? [];

                if (posts.isEmpty) {
                  return const Center(
                    child: Text("No posts available"),
                  );
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    print(post['marketPic']);
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
                            child: post['marketPic'] != null
                                ? Image.network(
                                    post['marketPic'],
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
                                  post['productName'] ?? 'No Title',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  post['price'] ?? 'No price',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                Text(
                                  post['description'] ?? 'No descritption',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: post['user']
                                                  ['profilePick'] !=
                                              null
                                          ? NetworkImage(
                                              post['user']['profilePick'])
                                          : AssetImage(
                                                  'assets/images/defaultPic.jpg')
                                              as ImageProvider,
                                    ), //Here there should be a change
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
                                    // #############################################
                                    GraphQLConsumer(
                                        builder: (GraphQLClient client) {
                                      return OutlinedButton(
                                        onPressed: () async {
                                          MutationOptions options =
                                              MutationOptions(
                                            document: gql(
                                              r"""
                                                mutation($sellerId:Int!){
                                                  createBussinessRoom(sellerId:$sellerId){
                                                    directRoomId
                                                  }
                                                }
                                              """,
                                            ),
                                            variables: {
                                              "sellerId":
                                                  int.parse(post['user']['id']),
                                            },
                                          );
                                          final result =
                                              await client.mutate(options);
                                          print(result);
                                          // if (result.hasException == true) {
                                          //   showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) {
                                          //       return AlertDialog(
                                          //         title: Text("Error"),
                                          //         content: Text(
                                          //             "Server is temporary unavailable"),
                                          //         actions: [
                                          //           TextButton(
                                          //               onPressed: () {
                                          //                 Navigator.pop(
                                          //                     context);
                                          //               },
                                          //               child: Text("Ok"))
                                          //         ],
                                          //       );
                                          //     },
                                          //   );
                                          // } else {
                                          final roomId = result
                                                  .data!['createBussinessRoom']
                                              ['directRoomId'];
                                          Navigator.pushNamed(
                                              context, '/private-bussines-room',
                                              arguments: roomId);
                                          // }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: kcolor,
                                            side: BorderSide(color: kcolor)),
                                        child: Text("talk with seller"),
                                      );
                                    }),
                                    // #############################################
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
    );
  }
}
