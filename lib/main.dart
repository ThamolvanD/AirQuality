/*import 'package:flutter/material.dart';
//import 'package:moblie/air_quality_page.dart';
//import 'package:moblie/form_example.dart';
//import 'package:moblie/registration_form.dart';
//import 'package:moblie/simple_api.dart' show ApiExampleList;
//import 'package:moblie/user_list_page.dart';
//import 'package:moblie/profilecard.dart';
import 'package:moblie/moblie1/Assignment_week5.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Assigmentweek5(), 
    );
  }
}*/


import 'package:flutter/material.dart' hide Card;
import 'package:moblie/page/card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Widget Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Card(),
    );
  }
}


