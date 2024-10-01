import'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:volunteerconnect/Configurations/routes.dart';

import 'package:get/get.dart';
import 'package:volunteerconnect/controllers/message_controller.dart';
import 'package:volunteerconnect/controllers/usercontroller.dart';

void main(){
  Get.put(UserController());
  //Get.put(MessageController());
  runApp(MyAPP());
}


class MyAPP extends StatelessWidget{
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
      return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.createaccount,
      getPages: Routes.routes,
    );
  }
}