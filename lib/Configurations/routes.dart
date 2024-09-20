import 'package:get/get.dart';
import 'package:volunteerconnect/Views/Screens/accountsettings.dart';
import 'package:volunteerconnect/Views/Screens/createaccount.dart';
import 'package:volunteerconnect/Views/Screens/homepage.dart';
import 'package:volunteerconnect/Views/Screens/login.dart';
import 'package:volunteerconnect/Views/Screens/messages.dart';
import 'package:volunteerconnect/Views/Screens/profile.dart';


class Routes {
  static const createaccount = '/createaccount';
  static const login = '/login';
  static const homepage = '/homepage';
  static const profile = '/profile';
  static const accountsettings= '/accountsettings';
  static const messages ='/messages';

  static final routes = [
    GetPage(name: createaccount, page: () => const Createaccount()),
    GetPage(name: login, page: () =>  LoginPage()),
    GetPage(name: homepage, page: () => const HomeScreen()),
    GetPage(name: profile, page: () =>  ProfilePage ()),
    GetPage(name: accountsettings, page: () =>  ProfilePageSettings ()),
    GetPage(name: messages, page: () =>   MyMessages ()),
  ];
}
