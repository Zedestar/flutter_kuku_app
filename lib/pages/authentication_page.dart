import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:kuku_app/token/token_helper.dart';
import 'package:kuku_app/widgets/app_bar.dart';
import 'package:kuku_app/widgets/form_input_vet.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  bool _vetMode = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _secondName = TextEditingController();
  final _phoneNumber = TextEditingController();
  File? vetCertificate;
  final _pageController = PageController();
  int _currentPage = 0;
  bool certifcateValidated = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _pageController.dispose();
    _phoneNumber.dispose();
    _secondName.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _toggleVetMode() {
    setState(() {
      _vetMode = !_vetMode;
    });
    _emailController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _secondName.clear();
    _phoneNumber.clear();
  }

  void _onPageChange(int pageNumber) {
    setState(() {
      _currentPage = pageNumber;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        vetCertificate = File(pickedFile.path);
      });
    }
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
      return 'Please enter your first name';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _secondnameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Second name can't be empty";
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

  String? _phoneNumberValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number can\'t be null';
    }
    if (!value.startsWith("+255")) {
      return "Start with +255";
    }
    if (value.length != 13) {
      return "Phonenumber should have 13 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> content = [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputFieldVetText(
              inputLabel: "firstname",
              inputHint: "Enter your firstname",
              textType: TextInputType.text,
              obscureText: false,
              maxmumlength: 50,
              theController: _usernameController,
              validation: _validateUsername,
            ),
            SizedBox(
              height: 20,
            ),
            InputFieldVetText(
              inputLabel: "secondname",
              inputHint: "Enter your second name",
              textType: TextInputType.text,
              obscureText: false,
              maxmumlength: 50,
              theController: _secondName,
              validation: _secondnameValidator,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputFieldVetText(
              inputLabel: "phone number",
              inputHint: "Enter your phone number",
              textType: TextInputType.phone,
              obscureText: false,
              maxmumlength: 13,
              theController: _phoneNumber,
              validation: _phoneNumberValidation,
            ),
            SizedBox(
              height: 20,
            ),
            InputFieldVetText(
              inputLabel: "email",
              inputHint: "Enter your email",
              textType: TextInputType.emailAddress,
              obscureText: false,
              maxmumlength: 50,
              theController: _emailController,
              validation: _validateEmail,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Upload your certificate"),
            SizedBox(
              height: 5,
            ),
            OutlinedButton(
              onPressed: pickImage,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: kcolor,
                ),
              ),
              child: Text("Take from gallery"),
            ),
            if (certifcateValidated) ...[
              Text(
                "Upload the certificate to continue",
                style: TextStyle(color: Colors.red),
              )
            ],
            if (vetCertificate != null) ...[
              Image.file(
                vetCertificate!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ]
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputFieldVetText(
              inputLabel: "password",
              inputHint: "Enter your password",
              textType: TextInputType.visiblePassword,
              obscureText: true,
              maxmumlength: 100,
              theController: _passwordController,
              validation: _validatePassword,
            ),
            SizedBox(
              height: 20,
            ),
            InputFieldVetText(
              inputLabel: "confirm password",
              inputHint: "Confirm your password",
              textType: TextInputType.visiblePassword,
              obscureText: true,
              maxmumlength: 100,
              theController: _confirmPasswordController,
              validation: _validateConfirmPassword,
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
      appBar: theAppBar(context, 'auth_page'),
      body: _vetMode != true
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 10.0,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          if (_isLogin == false) ...[
                            TextButton(
                              onPressed: _toggleVetMode,
                              child: Text("Signup as a vet"),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sing up as a Vet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: kcolor,
                            ),
                          ),
                          SizedBox(
                            height: 250,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: _onPageChange,
                              itemCount: content.length,
                              itemBuilder: (context, index) {
                                return content[index];
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: _currentPage > 0
                                    ? () {
                                        setState(() {
                                          _currentPage = _currentPage - 1;
                                          _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn,
                                          );
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kcolor),
                                child: Text("Back"),
                              ),
                              ...List.generate(
                                content.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  height: 8,
                                  width: _currentPage == index ? 20 : 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _currentPage == index
                                        ? kcolor
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _currentPage < content.length - 1
                                    ? () {
                                        setState(() {
                                          if (_currentPage == 0) {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              return;
                                            }
                                          } else if (_currentPage == 1) {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              return;
                                            }
                                          } else if (_currentPage == 2) {
                                            if (vetCertificate == null) {
                                              setState(() {
                                                certifcateValidated = true;
                                              });
                                              return;
                                            } else {
                                              setState(() {
                                                certifcateValidated = false;
                                              });
                                            }
                                          }
                                          _pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn,
                                          );
                                          _currentPage = _currentPage + 1;
                                        });
                                      }
                                    : () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kcolor),
                                child: Text(
                                  _currentPage < content.length - 1
                                      ? "Next"
                                      : "Signup",
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: _toggleVetMode,
                              child: Text("Signup as the farmer"))
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
