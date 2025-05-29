import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kuku_app/connection/connect_url.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(AppConfig.graphqlApiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query': '''
          mutation TokenAuth(\$username: String!, \$password: String!) {
            tokenAuth(username: \$username, password: \$password) {
              token
            }
          }
        ''',
        'variables': {
          'username': username,
          'password': password,
        }
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['data']['tokenAuth']['token'];

      // Save token securely
      await storage.write(key: 'jwt_token', value: token);
      print("User successifully logged in........................");
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  // Get JWT token from storage
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Log out and clear the stored token
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}
