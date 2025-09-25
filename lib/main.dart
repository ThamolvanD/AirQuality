import 'package:flutter/material.dart';
import 'package:moblie/air_quality_page.dart';
import 'package:moblie/form_example.dart';
import 'package:moblie/registration_form.dart';
import 'package:moblie/user_list_page.dart';
//import 'package:moblie/profilecard.dart';


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
      home: AirQualityPage(), 
    );
  }
}