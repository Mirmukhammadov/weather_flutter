import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp_starter_project/screens/home_screen.dart';
import 'package:weatherapp_starter_project/app_state.dart'; // Import the file where AppState is defined
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: HomeScreen(),
      title: "Weather",
      debugShowCheckedModeBanner: false,
    );
  }
}
