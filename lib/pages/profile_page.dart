import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/token/token_helper.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? present;
  void checkingIfUserHasLoggedIn() async {
    final token = await SecureStorageHelper.getToken();
    setState(() {
      present = token;
    });
  }

  @override
  void initState() {
    checkingIfUserHasLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(
        context,
        "My profile",
      ),
      body: present != null && present!.isNotEmpty
          ? Column(
              children: [
                const SizedBox(height: 20),
                GraphQLConsumer(
                  builder: (GraphQLClient client) {
                    final QueryOptions options = QueryOptions(
                        document: gql(
                          """
                                      query{
                              profile{
                                user{
                                  username
                                }
                                bio
                                profileUrl
                                facebook
                                phoneNumber
                                location
                              }
                            }
                          """,
                        ),
                        fetchPolicy: FetchPolicy.cacheAndNetwork);

                    final Future<QueryResult> queryResults =
                        client.query(options);
                    return FutureBuilder(
                      future: queryResults,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text("There is any errror occured"));
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return Text("you dont have profile yet");
                        }

                        final data = snapshot.data!.data?['profile'];
                        if (data == null) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("You dont have profile yet"),
                                OutlinedButton(
                                    onPressed: null,
                                    child: Text("Create Profile"))
                              ],
                            ),
                          );
                        }
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                data['profileUrl'],
                                // 'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg',
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                              data['bio'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                _StatBox(
                                    title: "24", subtitle: "Guides Created"),
                                _StatBox(
                                    title: "343 KM",
                                    subtitle: "Distance Travelled"),
                                _StatBox(title: "8", subtitle: "Trips Planned"),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // Settings List
                            const Divider(),
                            _ProfileItem(
                                icon: Icons.edit,
                                text: "Edit profile",
                                theActionOnTap: () {}),
                            _ProfileItem(
                                icon: Icons.credit_card,
                                text: "Billing",
                                theActionOnTap: () {}),

                            _ProfileItem(
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
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Login in required"),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth-page');
                      },
                      child: Text("Login"))
                ],
              ),
            ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatBox({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem(
      {required this.icon, required this.text, required this.theActionOnTap});
  final IconData icon;
  final String text;
  final VoidCallback theActionOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          icon,
        ),
        title: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: theActionOnTap);
  }
}
