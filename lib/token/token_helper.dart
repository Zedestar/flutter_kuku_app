import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: "token", value: token);
  }

  static Future<String?> getToken() async {
    String? token = await _secureStorage.read(key: "token");
    return token;
  }

  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: "token");
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:kuku_app/connection/connect_url.dart';

// class AuthService {
//   final storage = FlutterSecureStorage();

//   Future<String?> login(
//       {required BuildContext context,
//       required String username,
//       required String password}) async {
//     final response = await http.post(
//       Uri.parse(AppConfig.graphqlApiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(
//         {
//           'query': '''
//           mutation TokenAuth(\$username: String!, \$password: String!) {
//             tokenAuth(username: \$username, password: \$password) {
//               token
//             }
//           }
//         ''',
//           'variables': {
//             'username': username,
//             'password': password,
//           }
//         },
//       ),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final token = data['data']['tokenAuth']['token'];
//       await storage.write(key: 'jwt_token', value: token);
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Login Successful"),
//             content: Text("You have successfully logged in."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//       return token;
//     } else {
//       throw Exception('Failed to login');
//     }
//   }

//   // Get JWT token from storage
//   Future<String?> getToken() async {
//     return await storage.read(key: 'jwt_token');
//   }

//   // Log out and clear the stored token
//   Future<void> logout() async {
//     await storage.delete(key: 'jwt_token');
//   }
// }
