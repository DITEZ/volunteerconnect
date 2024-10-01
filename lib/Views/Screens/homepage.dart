import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:volunteerconnect/Models/constants.dart';
import 'package:volunteerconnect/Views/Screens/messages.dart';
import 'package:volunteerconnect/Views/Screens/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'dart:typed_data'; // For Base64 encoding
import 'package:volunteerconnect/views/screens/login.dart';
import 'package:volunteerconnect/controllers/message_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> volunteerOpportunities = [];
  final MessageController messageController = Get.put(MessageController());

  @override
  void initState() {
    super.initState();
    _fetchOpportunities(); // Fetch opportunities when the screen is loaded
  }

void _fetchOpportunities() async {
  try {
    final response = await http.get(
      Uri.parse('http://iknowuwatching.c1.biz/ted/apis/get_opportunities.php'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        final List<dynamic> data = responseData['opportunities'];

        setState(() {
          volunteerOpportunities.clear();
          volunteerOpportunities.addAll(data.map((item) {
            Uint8List? imageBytes;
            if (item['image'] != null && item['image'].isNotEmpty) {
              try {
                imageBytes = base64Decode(item['image']);
              } catch (e) {
                print('Error decoding image: $e');
              }
            }
            return {
              'id': item['id'],
              'location': item['location'],
              'date': item['date'],
              'description': item['description'],
              'contact': item['contact'],
              'imageBytes': imageBytes,
            };
          }).toList());
        });
      } else {
        print('API returned an error: ${responseData['error']}');
      }
    } else {
      print('Failed to fetch opportunities. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred while fetching opportunities: $e');
  }
}


  void _onDrawerIconPressed() {
    Get.to(() => ProfilePage());
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddOpportunityDialog(BuildContext context) {
    final _locationController = TextEditingController();
    final _dateController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _contactController = TextEditingController();
    String? _imagePath;

    final ImagePicker _picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Volunteer Opportunity"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: "Location"),
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: "Date"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: "Contact"),
                ),
                SizedBox(height: 12.0),
                TextButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _imagePath = image.path;
                      });
                    }
                  },
                  child: Text(
                    _imagePath == null
                        ? "Pick an Image"
                        : "Image Selected",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_locationController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _contactController.text.isNotEmpty) {
                  final response = await http.post(
                    Uri.parse(
                        'http://iknowuwatching.c1.biz/ted/apis/opportunities.php'),
                    body: {
                      'location': _locationController.text,
                      'date': _dateController.text,
                      'description': _descriptionController.text,
                      'contact': _contactController.text,
                      'image': _imagePath,
                    },
                  );

                  final responseData = json.decode(response.body);

                  if (responseData['success']) {
                    setState(() {
                      volunteerOpportunities.add({
                        'location': _locationController.text,
                        'date': _dateController.text,
                        'description': _descriptionController.text,
                        'contact': _contactController.text,
                        'image': _imagePath,
                      });
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    // Handle the error
                    print(responseData['message']);
                  }
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDeleteDialog(
      BuildContext context, Map<String, dynamic> opportunity, int index) {
    final _locationController =
        TextEditingController(text: opportunity['location']);
    final _dateController = TextEditingController(text: opportunity['date']);
    final _descriptionController =
        TextEditingController(text: opportunity['description']);
    final _contactController =
        TextEditingController(text: opportunity['contact']);
    String? _imagePath = opportunity['image'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit or Delete Opportunity"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: "Location"),
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: "Date"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: "Contact"),
                ),
                SizedBox(height: 12.0),
                TextButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      _imagePath = image.path;
                    }
                    setState(() {});
                  },
                  child: Text(
                    _imagePath == null
                        ? "Pick an Image "
                        : "Image Selected",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
    TextButton(
  onPressed: () async {
    // Prepare the data as a Map
    Map<String, dynamic> data = {
      'id': opportunity['id'].toString(),
      'location': _locationController.text,
      'date': _dateController.text,
      'description': _descriptionController.text,
      'contact': _contactController.text,
    };

    // Add image data if available
    if (_imagePath != null) {
      List<int> imageBytes = await File(_imagePath!).readAsBytes();
      String base64Image = base64Encode(imageBytes);
      data['image'] = base64Image;
    }

    // Convert the Map to JSON
    String jsonData = json.encode(data);

    // Send the request
    final response = await http.post(
      Uri.parse('http://iknowuwatching.c1.biz/ted/apis/update_opportunities.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );

    final responseData = json.decode(response.body);

    if (responseData['success']) {
      setState(() {
        volunteerOpportunities[index] = {
          'id': opportunity['id'],
          'location': _locationController.text,
          'date': _dateController.text,
          'description': _descriptionController.text,
          'contact': _contactController.text,
          'image': _imagePath,
        };
      });
      Navigator.of(context).pop(); // Close the dialog
    } else {
      // Handle the error
      print(responseData['message']);
    }
  },
  child: Text("Update"),
),
           TextButton(
  onPressed: () async {
    // Prepare the data as a Map
    Map<String, dynamic> data = {
      'id': opportunity['id'].toString(),
    };

    // Convert the Map to JSON
    String jsonData = json.encode(data);

    // Send the delete request
    final response = await http.post(
      Uri.parse('http://iknowuwatching.c1.biz/ted/apis/delete_opportunities.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );

    final responseData = json.decode(response.body);

    if (responseData['success']) {
      setState(() {
        volunteerOpportunities.removeAt(index);
      });
      Navigator.of(context).pop(); // Close the dialog
    } else {
      // Handle the error
      print(responseData['message']);
      // You might want to show an error message to the user here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete opportunity: ${responseData['message']}')),
      );
    }
  },
  child: Text("Delete"),
  style: TextButton.styleFrom(foregroundColor: Colors.red),
),
          ],
        );
      },
    );
  }

  void _onOpportunityTapped(Map<String, dynamic> opportunity) {
    // Update the message screen with the selected opportunity's description
    Get.to(() => MyMessages(), arguments: {
      'description': opportunity['description'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String username = args['username'] ??
        'John Doe'; // Default to 'John Doe' if username is not passed

    return Scaffold(
      backgroundColor: kSilver,
      appBar: AppBar(
        elevation: 0.0,
        leading: Padding(
          padding: EdgeInsets.only(
            left: 18.0,
            top: 12.0,
            bottom: 12.0,
            right: 12.0,
          ),
          child: InkWell(
            onTap: _onDrawerIconPressed,
            child: Image.asset('lib/assets/images/drawer.png'),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right:
                    16.0), // Adjust the value to move the image further to the left
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(kBlack,
                  BlendMode.modulate), // Apply color filter to tint the image
              child: SizedBox(
                width: 25.0, // Set the width of the image
                child: GestureDetector(
                  onTap: () {
                    // Using GetX to navigate to another page
                    Get.to(() => MyMessages());
                  },
                  child: Image.asset(
                    'lib/assets/images/email.png',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Text(
              'Hi $username,\nfind volunteer opportunities below',
              style: kPageTitleStyle,
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(right: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextField(
                        cursorColor: kBlack,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            size: 25.0,
                            color: kBlack,
                          ),
                          border: InputBorder.none,
                          hintText: "Search volunteer opportunities",
                          hintStyle: kSubtitleStyle.copyWith(
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    margin: EdgeInsets.only(left: 12.0),
                    decoration: BoxDecoration(
                      color: kBlack,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Icon(
                      FontAwesomeIcons.slidersH,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Text(
              "Opportunities list",
              style: kTitleStyle,
            ),
            SizedBox(height: 15.0),
            // Main ListView builder to display opportunities horizontally
          Expanded(
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: volunteerOpportunities.length,
    itemBuilder: (context, index) {
      final opportunity = volunteerOpportunities[index];
      return GestureDetector(
        onTap: () {
          messageController.addOpportunity(opportunity['description']);
          Get.to(
            () => MyMessages(),
            arguments: 'You have selected the following opportunity: ${opportunity['description']}',
          );
        },
        child: Container(
          width: 300,
          margin: EdgeInsets.only(right: 18.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (opportunity['imageBytes'] != null)
                  GestureDetector(
                    onTap: () => _showFullImage(context, opportunity['imageBytes']),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.memory(
                        opportunity['imageBytes'], // Load image from memory
                        width: double.infinity,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 8.0),
                Text(
                  opportunity['location'],
                  style: kSubtitleStyle.copyWith(
                    color: kBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  opportunity['date'],
                  style: kSubtitleStyle.copyWith(color: Colors.black54),
                ),
                SizedBox(height: 4.0),
                Text(
                  opportunity['description'],
                  style: kSubtitleStyle.copyWith(color: kBlack),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  'Contact: ${opportunity['contact']}',
                  style: kSubtitleStyle.copyWith(color: kBlack),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the button
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showEditDeleteDialog(context, opportunity, index);
                      },
                      child: Text("Modify"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: Colors.blue, // Button color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
)



          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOpportunityDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  } 
}
