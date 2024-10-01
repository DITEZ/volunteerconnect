import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteerconnect/Controllers/message_controller.dart';

class MyMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Safely get the message, providing a default if it's null
    final String message = Get.arguments as String? ?? 'No message available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(message),
          ),
          // Add more messages or widgets here if needed
        ],
      ),
    );
  }
}
