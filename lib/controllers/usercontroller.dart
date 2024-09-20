import 'package:get/get.dart';

class UserController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;

  void updateUsername(String newUsername) {
    username.value = newUsername;
    email.value = newUsername + '@gmail.com';
  }
}
