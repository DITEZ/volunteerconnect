import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Createaccount(),
    );
  }
}

class Createaccount extends StatefulWidget {
  const Createaccount({Key? key}) : super(key: key);

  @override
  _CreateaccountState createState() => _CreateaccountState();
}

class _CreateaccountState extends State<Createaccount> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _confirmPasswordTextController;
  TextEditingController _phoneNumberController = TextEditingController();
  bool _passwordVisibility = false;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    final email = _emailTextController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final password = _passwordTextController.text.trim();
    final confirmPassword = _confirmPasswordTextController.text.trim();

    if (email.isEmpty || phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match.');
      return;
    }

    final response = await http.post(
      Uri.parse('http://iknowuwatching.c1.biz/ted/apis/createaccount.php'),
      body: {
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody.contains('Account created successfully')) {
        Get.snackbar('Success', 'Account created successfully.');
        // Navigate to login page if the account creation was successful
        Get.toNamed('/login');
      } else {
        Get.snackbar('Error', responseBody);
      }
    } else {
      Get.snackbar('Error', 'Failed to create account. Please try again.');
    }
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
                                        controller: _emailTextController,
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                          hintStyle: TextStyle(color: Color(0x7F455A64)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
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
                                      child: InternationalPhoneNumberInput(
                                        onInputChanged: (PhoneNumber number) {
                                          _phoneNumber = number;
                                        },
                                        initialValue: _phoneNumber,
                                        textFieldController: _phoneNumberController,
                                        inputDecoration: InputDecoration(
                                          hintText: 'Phone Number',
                                          hintStyle: TextStyle(color: Color(0x7F455A64)),
                                          border: InputBorder.none,
                                        ),
                                        selectorConfig: SelectorConfig(
                                          selectorType: PhoneInputSelectorType.DIALOG,
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode: AutovalidateMode.disabled,
                                        selectorTextStyle: TextStyle(color: Colors.black),
                                        onSaved: (PhoneNumber number) {
                                          print('On Saved: ${number.phoneNumber}');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 20),
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
                                        controller: _passwordTextController,
                                        obscureText: !_passwordVisibility,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          hintStyle: TextStyle(color: Color(0x7F455A64)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          suffixIcon: IconButton(
                                            icon: Icon(_passwordVisibility ? Icons.visibility : Icons.visibility_off),
                                            onPressed: () => setState(() => _passwordVisibility = !_passwordVisibility),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 20),
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
                                        controller: _confirmPasswordTextController,
                                        obscureText: !_passwordVisibility,
                                        decoration: InputDecoration(
                                          hintText: 'Confirm Password',
                                          hintStyle: TextStyle(color: Color(0x7F455A64)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                          suffixIcon: IconButton(
                                            icon: Icon(_passwordVisibility ? Icons.visibility : Icons.visibility_off),
                                            onPressed: () => setState(() => _passwordVisibility = !_passwordVisibility),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                  child: ElevatedButton(
                                    onPressed: _createAccount,
                                    child: Text('Create Account'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigate to login page or perform other actions
                                    Get.toNamed('/login');
                                  },
                                  child: Text(
                                    'Already have an account? Click here',
                                    style: TextStyle(
                                      fontFamily: 'Playfair Display',
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
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
