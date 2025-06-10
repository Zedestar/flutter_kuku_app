import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:kuku_app/token/token_helper.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      if (_isLogin) {
        print('Logging in with: $username, $password');

        MutationOptions options = MutationOptions(
          document: gql(
            r"""
              mutation($username: String!, $password: String!){
                tokenAuth(username: $username, password: $password){
                  token
                  payload
                }
              }
           """,
          ),
          variables: {
            "username": username,
            "password": password,
          },
        );

        final client = GraphQLProvider.of(context).value;
        client.mutate(options).then(
          (result) {
            if (result.hasException) {
              print('Login failed: ${result.exception.toString()}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Login failed: ${result.exception.toString()}')),
              );
            } else {
              String token = result.data!['tokenAuth']['token'];
              SecureStorageHelper.saveToken(token);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login successful'),
                ),
              );
              Navigator.pushReplacementNamed(context, '/home-page');
            }
          },
        );
      } else {
        String confirmPassword = _confirmPasswordController.text;
        print('Signing up with: $username, $password, $confirmPassword');

        // The signing up logic
        MutationOptions options = MutationOptions(
            document: gql(
              r"""
              mutation($username:String!, $email:String!, $password:String!){
              createUser(username:$username, email:$email, password:$password){
              user{
                username
              } 
            }
            }
           """,
            ),
            variables: {
              "username": _usernameController.text,
              "email": _emailController.text,
              "password": _passwordController.text
            });

        final client = GraphQLProvider.of(context).value;
        client.mutate(options).then(
          (result) {
            if (result.hasException) {
              print('Login failed: ${result.exception.toString()}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Login failed: ${result.exception.toString()}')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You have created account successful'),
                ),
              );
              Navigator.pushReplacementNamed(context, '/auth-page');
            }
          },
        );
        // Signing up logic
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 3) {
      return 'Password must be at least 3 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_isLogin && (value == null || value.isEmpty)) {
      return 'Please confirm your password';
    }
    if (!_isLogin && value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, 'auth_page'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      _isLogin ? 'login'.tr() : 'sign_up'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: kcolor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 16.0),
                    if (!_isLogin) ...[
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateEmail,
                      ),
                    ],
                    const SizedBox(height: 24.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validatePassword,
                    ),
                    if (!_isLogin) ...[
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateConfirmPassword,
                      ),
                    ],
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: Text(_isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(fontSize: 18.0)),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        _isLogin
                            ? 'instruction_on_signing_up'.tr()
                            : 'already_have_account_instruction'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
