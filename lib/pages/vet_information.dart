import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/widgets/app_bar.dart';
import 'package:kuku_app/widgets/profile_list_items.dart';
import 'package:kuku_app/widgets/profile_stats_box.dart';

class VetInfoPage extends StatelessWidget {
  const VetInfoPage({super.key, required this.vetId, required this.vetName});

  final int vetId;
  final String vetName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: theAppBar(context, "Vet $vetName"),
        body: Column(
          children: [
            const SizedBox(height: 20),
            GraphQLConsumer(
              builder: (GraphQLClient client) {
                final QueryOptions options = QueryOptions(
                    document: gql(
                      """
                                     query(\$vetId:Int){
  profile(vetId:\$vetId){
    user{
      username
      profilePick
      email
    }
    
    location
    facebook
  }
}
                          """,
                    ),
                    variables: {"vetId": vetId},
                    fetchPolicy: FetchPolicy.noCache);

                final Future<QueryResult> queryResults = client.query(options);
                return FutureBuilder(
                  future: queryResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // if(snapshot)

                    if (snapshot.hasError) {
                      return Center(child: Text("There is any errror occured"));
                    }

                    if (snapshot.data!.hasException == true) {
                      final theException =
                          snapshot.data!.hasException.toString();
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("The vet has not yet created the profile"),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Go back"),
                            ),
                          ],
                        ),
                      );
                    }

                    //   showDialog(
                    //     context: context,
                    //     builder: (context) => AlertDialog(
                    //       title: Text("Profile Error"),
                    //       content: Text(theException),
                    //       actions: [
                    //         TextButton(
                    //           child: Text("OK"),
                    //           onPressed: () => Navigator.of(context).pop(),
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Text("you dont have profile yet");
                    }

                    final data = snapshot.data!.data?['profile'];
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            data['user']?['profilePick'] ??
                                'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // "The username",
                              data['user']['username'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 6),
                            Chip(
                              label: Text("Farmer",
                                  style: TextStyle(color: Colors.blue)),
                              avatar: Icon(Icons.verified,
                                  color: Colors.blue, size: 18),
                              // backgroundColor: Colors.blue.shade50,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ],
                        ),
                        Text(
                          // "the Bio",
                          data['bio'] ?? "The bio not yet set",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            ProfileStatsBox(
                                title: "24", subtitle: "Guides Created"),
                            ProfileStatsBox(
                                title: "343 KM",
                                subtitle: "Distance Travelled"),
                            ProfileStatsBox(
                                title: "8", subtitle: "Trips Planned"),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Settings List
                        const Divider(),
                        ProfileListItems(
                            icon: Icons.edit,
                            text: "Edit profile",
                            theActionOnTap: () {}),
                        ProfileListItems(
                            icon: Icons.credit_card,
                            text: "Billing",
                            theActionOnTap: () {}),

                        ProfileListItems(
                          icon: Icons.home_outlined,
                          text: "Home",
                          theActionOnTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/home-page');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ));
  }
}
