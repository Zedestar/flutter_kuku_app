import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:kuku_app/graphql/graphql_mutations.dart';
import 'package:kuku_app/token/token_helper.dart';
import 'package:kuku_app/widgets/app_bar.dart';
import 'package:kuku_app/widgets/form_input_widget.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:kuku_app/widgets/profile_list_items.dart';
import 'package:kuku_app/widgets/profile_stats_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? present;
  File? _image;
  final profileNameEditingController = TextEditingController();
  final bioEditingController = TextEditingController();
  final faceBookeEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final locationEditingController = TextEditingController();

  Future<void> pickImage() async {
    final pickImage = ImagePicker();
    final pickedFile = await pickImage.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // String? validator(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return "This string can't be empty";
  //   }
  //   return
  // }

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
  void dispose() {
    super.dispose();
    phoneEditingController.dispose();
    bioEditingController.dispose();
    faceBookeEditingController.dispose();
    profileNameEditingController.dispose();
    locationEditingController.dispose();
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
                                  role
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
                        fetchPolicy: FetchPolicy.noCache);

                    final Future<QueryResult> queryResults =
                        client.query(options);
                    return FutureBuilder(
                      future: queryResults,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        // if(snapshot)

                        if (snapshot.hasError) {
                          return Center(
                              child: Text("There is any errror occured"));
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return Text("you dont have profile yet");
                        }

                        final data = snapshot.data!.data?['profile'];
                        // THIS IS SPECIAL BROCK THAT IS IF USER HAS NO PRFILE THE THIS WILL DISPLAY
                        if (data == null) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("You dont have profile yet"),
                                OutlinedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.8,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Form(
                                                child: Column(
                                                  children: [
                                                    FormInputWidget(
                                                      inputLabel: "Bio",
                                                      inputHint:
                                                          "Enter you bio",
                                                      maxmumlength: 250,
                                                      theController:
                                                          bioEditingController,
                                                      textType:
                                                          TextInputType.text,
                                                    ),
                                                    FormInputWidget(
                                                      inputLabel: "Location",
                                                      inputHint:
                                                          "Enter you Location",
                                                      maxmumlength: 50,
                                                      theController:
                                                          locationEditingController,
                                                      textType:
                                                          TextInputType.text,
                                                    ),
                                                    FormInputWidget(
                                                      inputLabel: "Phone",
                                                      inputHint:
                                                          "Enter you phonenumber",
                                                      maxmumlength: 114,
                                                      theController:
                                                          phoneEditingController,
                                                      textType:
                                                          TextInputType.number,
                                                    ),
                                                    FormInputWidget(
                                                      inputLabel: "Email",
                                                      inputHint:
                                                          "Enter you email",
                                                      maxmumlength: 25,
                                                      theController:
                                                          faceBookeEditingController,
                                                      textType: TextInputType
                                                          .emailAddress,
                                                    ),
                                                    GestureDetector(
                                                      onTap: pickImage,
                                                      child: _image == null
                                                          ? Container(
                                                              height: 150,
                                                              width: 150,
                                                              color: Colors
                                                                  .grey[300],
                                                              child: Icon(Icons
                                                                  .add_a_photo),
                                                            )
                                                          : Image.file(
                                                              _image!,
                                                              height: 150,
                                                              width: 150,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                    GraphQLConsumer(
                                                      builder: (GraphQLClient
                                                          client) {
                                                        return ElevatedButton(
                                                          onPressed: () async {
                                                            if (_image ==
                                                                null) {
                                                              // handle no image selected, maybe show error or return
                                                              print(
                                                                  'No image selected');
                                                              return;
                                                            }

                                                            // Read bytes from the file
                                                            final bytes =
                                                                await _image!
                                                                    .readAsBytes();

                                                            // Create MultipartFile from bytes
                                                            final multipartFile =
                                                                http.MultipartFile
                                                                    .fromBytes(
                                                              'profileImage',
                                                              bytes,
                                                              filename: _image!
                                                                  .path
                                                                  .split('/')
                                                                  .last,
                                                              contentType:
                                                                  MediaType(
                                                                      'image',
                                                                      'jpeg'), // or 'png' based on file type
                                                            );

                                                            // Now create mutation options with the multipartFile in variables
                                                            final MutationOptions
                                                                options =
                                                                MutationOptions(
                                                              document: gql("""
                                                                      mutation CreateProfile(
                                                                        \$bio: String!,
                                                                        \$location: String!,
                                                                        \$phone: String!,
                                                                        \$email: String!,
                                                                        \$profileImage: Upload!
                                                                      ) {
                                                                        createProfile(
                                                                          bio: \$bio,
                                                                          location: \$location,
                                                                          phone: \$phone,
                                                                          email: \$email,
                                                                          profileImage: \$profileImage
                                                                        ) {
                                                                          profile {
                                                                            bio
                                                                            profileUrl
                                                                          }
                                                                        }
                                                                      }
                                                                    """),
                                                              variables: {
                                                                'bio':
                                                                    bioEditingController
                                                                        .text,
                                                                'location':
                                                                    locationEditingController
                                                                        .text,
                                                                'phone':
                                                                    phoneEditingController
                                                                        .text,
                                                                'email':
                                                                    faceBookeEditingController
                                                                        .text,
                                                                'profileImage':
                                                                    multipartFile, // here we pass the multipart file
                                                              },
                                                            );

                                                            // Perform the mutation
                                                            final result =
                                                                await client
                                                                    .mutate(
                                                                        options);

                                                            if (result
                                                                .hasException) {
                                                              print(result
                                                                  .exception
                                                                  .toString());
                                                            } else {
                                                              print(
                                                                  result.data);
                                                              // Maybe show success or update UI here
                                                            }
                                                          },
                                                          child: Text(
                                                              "Create Profile"),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text("Create Profile"),
                                ),
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
                                  label: Text(data['user']['role'],
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
                              data['bio'] ?? "Hey there am the pault farmer",
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
