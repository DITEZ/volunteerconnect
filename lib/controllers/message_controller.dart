import 'package:get/get.dart';

class MessageController extends GetxController {
   var selectedOpportunities = <String>[].obs;

  void addOpportunity(String opportunityDescription) {
    selectedOpportunities.add(opportunityDescription);
  }
}
