import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisibility = false;

Future<void> _login() async {
  final String email = _emailController.text.trim();
  final String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    _showDialog('Error', 'Please enter both email and password.');
    return;
  }

  try {
    final url = Uri.parse('http://iknowuwatching.c1.biz/ted/apis/login.php');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.headers['content-type']?.contains('application/json') == true) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['message'] == "Login successful!") {
        String username = responseData['username'];
        _showDialog('Success', responseData['message']);
        Get.toNamed('/homepage', arguments: {'username': username});
      } else {
        _showDialog('Login Failed', responseData['message'] ?? 'Unknown error');
      }
      
    } else {
      _showDialog('Error', 'Unexpected response format');
      print('Unexpected response format: ${response.body}');
    }
  } catch (e) {
    _showDialog('Error', 'An unexpected error occurred: $e');
    print('Error during login: $e');
  }
  
}


  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0, -1),
            child: Image.asset(
              'lib/assets/images/austin.jpg',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 180, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                              child: Image.asset(
                                'lib/assets/images/VC.png',
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 15),
                                  child: Container(
                                    width: 300,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE0E0E0),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                                      child: TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                          hintStyle: TextStyle(color: Color(0x7F455A64)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 15),
                                  child: Container(
                                    width: 300,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE0E0E0),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: !_passwordVisibility,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          hintStyle: TextStyle(color: Color(0x7F455A64)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                                _passwordVisibility ? Icons.visibility : Icons.visibility_off),
                                            onPressed: () =>
                                                setState(() => _passwordVisibility = !_passwordVisibility),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    child: Text('Log in'),
                                  ),
                                ),
                                // Continue as Guest Button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Get.toNamed('/homepage');// Add guest logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(300, 50),
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      backgroundColor: Colors.white,
                                      textStyle: TextStyle(color: Colors.black),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    icon: Icon(Icons.person, color: Colors.black),
                                    label: Text('Continue as Guest'),
                                  ),
                                ),
                                // Sign in with Google Button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Add Google sign-in logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(300, 50),
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      backgroundColor: Colors.white,
                                      textStyle: TextStyle(color: Colors.black),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'lib/assets/images/google_icon.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    label: Text('Sign in with Google'),
                                  ),
                                ),
                                // Sign in with Facebook Button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Add Facebook sign-in logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(300, 50),
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      backgroundColor: Colors.white,
                                      textStyle: TextStyle(color: Colors.black),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'lib/assets/images/facebook_logo.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    label: Text('Sign in with Facebook'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
