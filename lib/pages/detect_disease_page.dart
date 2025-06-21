import 'dart:io';
// import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kuku_app/token/token_helper.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class PredictDiseaseScreen extends StatefulWidget {
  const PredictDiseaseScreen({super.key});

  @override
  State<PredictDiseaseScreen> createState() => _PredictDiseaseScreenState();
}

class _PredictDiseaseScreenState extends State<PredictDiseaseScreen> {
  File? _image;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> cameraImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, "detect_disease"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "info_text".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final token = await SecureStorageHelper.getToken();
                print(token);

                if (token != null) {
                  pickImage();
                } else {
                  Navigator.pushNamed(context, '/auth-page');
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kcolor, foregroundColor: Colors.white),
              child: Text("Pick Image"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final token = await SecureStorageHelper.getToken();
                if (token != null) {
                  cameraImage();
                } else {
                  Navigator.pushNamed(context, '/auth-page');
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kcolor, foregroundColor: Colors.white),
              child: Text("Take picture"),
            ),
            if (_image != null) ...[
              Image.file(
                _image!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              GraphQLConsumer(
                builder: (GraphQLClient client) {
                  return ElevatedButton(
                    onPressed: () async {
                      final byte = await _image!.readAsBytes();
                      final multipartFile = http.MultipartFile.fromBytes(
                        "sampleImage",
                        byte,
                        filename: _image!.path.split('/').last,
                        contentType: MediaType('image', 'jpeg'),
                      );

                      final MutationOptions options = MutationOptions(
                        document: gql(r"""
                            mutation($sampleImage:Upload!){
                            predictDisease(sampleImage:$sampleImage){
                              prediction
                              confidenceLevel
                            }
                          }     
                          """),
                        variables: {"sampleImage": multipartFile},
                      );
                      final result = await client.mutate(options);

                      if (result.hasException) {
                        print("Still there is a problem");
                        print(result.exception.toString());
                      } else {
                        final data = result.data;
                        if (data == null) {
                          print("There is no response");
                          return;
                        }
                        final String diseaseAnalyzed =
                            data['predictDisease']['prediction'];
                        final String confidence =
                            data['predictDisease']['confidenceLevel'];
                        Navigator.pushNamed(context, '/sample-page');
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Diagnoise successful"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(diseaseAnalyzed),
                                    Text(confidence)
                                  ],
                                ),
                              );
                            });
                      }
                    },
                    child: Text(
                      "Diagnonize",
                      style: TextStyle(color: kcolor),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}


  // To send image for prediction
  // Future<void> sendImageForPrediction() async {
  //   if (_image == null) return;

  //   var uri = Uri.parse('http://192.168.1.112:8000/predict/');
  //   // var uri = Uri.parse(AppConfig.apiUrl);
  //   var request = http.MultipartRequest('POST', uri);

  //   final token = await SecureStorageHelper.getToken();
  //   if (token == null) {
  //     print("No token found");
  //     return;
  //   }

  //   request.headers['Authorization'] = 'Bearer $token';
  //   var multipartFile = await http.MultipartFile.fromPath(
  //     'sample_image',
  //     _image!.path,
  //     contentType: MediaType('application', 'octet-stream'),
  //   ); // Set the correct media type for the image
  //   request.files.add(multipartFile);

  //   // Send the request and get the streamed response
  //   var streamedResponse = await request.send();

  //   // Convert streamedResponse to a normal response
  //   var response = await http.Response.fromStream(streamedResponse);

  //   // Decode the JSON response body
  //   var data = jsonDecode(response.body);
  //   print(data);

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print("Prediction Success");
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Prediction Result'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text('Prediction: ${data['prediction']}'),
  //               Text(
  //                   'Confidence Level: ${data['confidence_level'].toStringAsFixed(2)}'),
  //               Text('Time Taken: ${data['time_taken']}'),
  //             ],
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //               child: Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );

  //     // Handle the response
  //   } else {
  //     print("Prediction Failed");
  //   }
  // }