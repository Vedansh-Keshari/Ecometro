import 'package:ecometro/screens/homepage.dart';
import 'package:ecometro/screens/loginPage.dart';
import 'package:ecometro/screens/signupPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    theme: ThemeData(
      primaryColor: Colors.green, // Set primary color to green
    ),
  ));
}