import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
//import 'login_page_widget.dart' show LoginPageWidget;

class LoginPageModel extends StatefulWidget {
  final Widget child;

  const LoginPageModel({Key? key, required this.child}) : super(key: key);

  set textFieldFocusNode1(FocusNode textFieldFocusNode1) {}

  @override
  _LoginPageModelState createState() => _LoginPageModelState();
}

class _LoginPageModelState extends State<LoginPageModel> {
  /// State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();

    textFieldFocusNode2?.dispose();
    passwordTextController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
