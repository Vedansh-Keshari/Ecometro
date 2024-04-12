import 'package:ecometro/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isEmailFocused = false;
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: RichText(
                  textAlign: TextAlign.center, // Center align text
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'ECO ',
                        style: TextStyle(
                          color: Colors.green, // Set ECO text color to green
                          fontSize: 24.0, // Set font size
                          fontWeight: FontWeight.bold, // Set font weight
                        ),
                      ),
                      TextSpan(
                        text: 'METRO',
                        style: TextStyle(
                          color: Colors.black, // Set METRO text color to black
                          fontSize: 24.0, // Set font size
                          fontWeight: FontWeight.bold, // Set font weight
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYZ6fWqAirU2Kd8LEmUf8STRfoaiAf_WpG4JEzEjSlnQ&s',
                height: 100.0,
                width: 100.0,
              ),
              SizedBox(height: 20.0),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isEmailFocused ? 60.0 : 45.0,
                child: TextFormField(
                  onTap: () {
                    setState(() {
                      isEmailFocused = true;
                    });
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.email),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: _obscurePassword,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Sign Up'),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Navigate to login page
                  // Example:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Already have an account? Login here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final url = Uri.parse('http://127.0.0.1:5000/register');
    final data = {
      'email': emailController.text,
      'password': passwordController.text,
      'phone_number': phoneNumberController.text,
      'name': nameController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        // User successfully signed up
        print('User signed up successfully!');
        // Show signup success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign Up Successful'),
            duration: Duration(seconds: 3),
          ),
        );
        // Navigate to the login page
        // Example:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        // Failed to sign up
        print('Failed to sign up. Status code: ${response.statusCode}');
        // Display an error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign Up Error'),
              content: Text('Failed to sign up. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Exception occurred
      print('Error occurred: $e');
      // Display an error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign Up Error'),
            content: Text('Failed to sign up. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
