import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp_starter_project/app_state.dart';
import 'package:weatherapp_starter_project/controller/global_controller.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

// class HeaderController extends GetxController {
//   RxString userInput = 'Tashkent'.obs;
// }

class _HeaderWidgetState extends State<HeaderWidget> {
  late TextEditingController _controller;
  late String _storedValue;
  late TextEditingController userInputController;
  String userInput = 'Tashkent';

  @override
  void initState() {
    super.initState();
    userInputController = TextEditingController();
    _controller = TextEditingController();
    loadStoredValue();
    getAddress(globalController.getLattitude().value,
        globalController.getLongitude().value);
    super.initState();
  }

  late String city = "";
  String date = DateFormat("yMMMMd").format(DateTime.now());

  loadStoredValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedValue = prefs.getString('city') ?? 'Default Value';
      city = userInput;
    });
  }

  Future<void> loadUserInput() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userInput = prefs.getString('userInput') ?? 'Tashkent';
      userInputController.text = userInput;
    });
  }

  Future<void> saveUserInput(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInput', value);
  }

  void validateAndSave() {
    String input = userInputController.text.trim();

    if (input.isNotEmpty) {
      setState(() {
        userInput = input;
      });
      saveUserInput(input);
    } else {
      // Handle validation error (e.g., show a message to the user)
      print('Validation error: Input cannot be empty.');
    }
  }

  saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('city', userInput);
    loadStoredValue();
  }

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  getAddress(lat, lon) async {
    setState(() {
      city = userInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.topLeft,
          child: Text(
            city,
            style: const TextStyle(fontSize: 35, height: 2),
          ),
        ),
        // Container(
        //   margin: const EdgeInsets.only(left: 20, right: 20),
        //   alignment: Alignment.topLeft,
        //   child: TextField(
        //     // controller: _textController,
        //     decoration: InputDecoration(labelText: 'Enter your text'),
        //   ),
        //   SizedBox(height: 20),
        //   ElevatedButton(
        //     onPressed: () {
        //       // Access the user input from the text controller
        //       // String userInput = _textController.text;

        //       // Do something with the user input, for example, print it
        //       // print('User Input: $userInput');
        //     },
        //     child: Text('Submit'),
        //   ),
        //   ),
        // ),

        // Container(
        //   margin: const EdgeInsets.only(left: 20, right: 20),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       TextField(
        //         // controller: _textController,
        //         decoration: InputDecoration(labelText: 'Enter your text'),
        //       ),
        //       SizedBox(height: 20),
        //       ElevatedButton(
        //         onPressed: () {
        //           // Access the user input from the text controller
        //           // String userInput = _textController.text;

        //           // Do something with the user input, for example, print it
        //           // print('User Input: $userInput');
        //         },
        //         child: Text('Submit'),
        //       ),
        //     ],
        //   ),
        // ),

        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          alignment: Alignment.topLeft,
          child: Text(
            date,
            style:
                TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
        ),

        Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        userInput = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Enter your text'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    saveValue();
                    fetchLocation();
                    loadUserInput();
                  },
                  child: const Text('submit'),
                ),
              ],
            )),
      ],
    );
  }
}
