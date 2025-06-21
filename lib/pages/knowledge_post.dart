import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:kuku_app/graphql/graphql_queries.dart';
import 'package:http/http.dart' as http;

class KnowledgePostPage extends StatefulWidget {
  const KnowledgePostPage({super.key});

  @override
  State<KnowledgePostPage> createState() => _KnowledgePostPageState();
}

class _KnowledgePostPageState extends State<KnowledgePostPage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _titleController = TextEditingController();
  final _captionController = TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          return FutureBuilder<QueryResult>(
            future: client.query(
              QueryOptions(
                  document: gql(generalPostQuery),
                  fetchPolicy: FetchPolicy.networkOnly),
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
                    snapshot.data?.data?['posts'] as List<dynamic> ?? [];

                if (posts.isEmpty) {
                  return const Center(
                    child: Text("No posts available"),
                  );
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    print(post['pictureUrl']);
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
                            child: post['pictureUrl'] != null
                                ? Image.network(
                                    post['pictureUrl'],
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
                                  post['title'] ?? 'No Title',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  post['caption'] ?? 'No no Caption',
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: kcolor),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/generalPostDetailsView',
                                            arguments: post);
                                      },
                                      child: Text("View"),
                                    )
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: kcolor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Create New Post",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kcolor)),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: pickImage,
                          child: Text(
                            "Picke image",
                            style: TextStyle(color: kcolor),
                          ),
                        ),
                        if (_imageFile != null) ...[
                          Image.file(
                            _imageFile!,
                            height: 150,
                            width: 150,
                          )
                        ],
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: "Title"),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Title is required'
                              : null,
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _captionController,
                          decoration:
                              InputDecoration(labelText: " Post caption "),
                          maxLines: 3,
                        ),
                        SizedBox(height: 16),
                        GraphQLConsumer(
                          builder: (GraphQLClient client) {
                            return ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      _imageFile != null) {
                                    final byte =
                                        await _imageFile!.readAsBytes();
                                    final multipartFile =
                                        http.MultipartFile.fromBytes(
                                      "photo",
                                      byte,
                                      filename:
                                          _imageFile!.path.split('/').last,
                                      contentType: MediaType('image', 'jpeg'),
                                    );

                                    final MutationOptions options =
                                        MutationOptions(
                                      document: gql(r"""
                                        mutation CreateNewPost($title: String!, $caption: String!, $photo: Upload!) {
                                          createPost(title: $title, caption: $caption, photo: $photo) {
                                          post {
                                            id
                                            title
                                            caption
                                            pictureUrl
                                            createdAt
                                          }
                                        }
                                      }
                                     """),
                                      variables: {
                                        "title": _titleController.text,
                                        "caption": _captionController.text,
                                        "photo": multipartFile
                                      },
                                    );
                                    final result = await client.mutate(options);
                                    if (result.hasException) {
                                      print(result);
                                    } else {
                                      print("Sucesssss");
                                    }

                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please complete all fields and pick an image')),
                                    );
                                  }
                                },
                                child: Text("Create Post"));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Text(
          "Create Post",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
