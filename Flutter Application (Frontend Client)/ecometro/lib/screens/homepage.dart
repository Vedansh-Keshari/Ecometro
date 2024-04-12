import 'package:ecometro/screens/loginPage.dart';
import 'package:ecometro/screens/procurement.dart';
import 'package:flutter/material.dart';
import 'package:ecometro/screens/chatbot.dart'; // Assuming this is where you have your ChatbotPage
// Import other necessary packages and files

class HomePage extends StatelessWidget {
  final String userName; // User's name

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoMetro'),
        backgroundColor: Colors.green, // Change app bar color to green
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName), // Display user's name
              accountEmail: null, // You can show user's email here if needed
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: const Text('Calculate Emissions'), // Updated label
              onTap: () {
                // Navigation...
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart), // Changed to shopping cart icon
              title: const Text('Procurement'), // Updated label
              onTap: () {
                // Navigation...
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProcurementPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person), // View Profile icon
              title: const Text('View Profile'), // Updated label
              onTap: () {
                // Navigate to profile screen
                // Example:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout), // Logout icon
              title: const Text('Logout'), // Updated label
              onTap: () {
                // Perform logout action
                // Example:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30.0),
              // Widgets...
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSquareButton(
                    Icons.calculate,
                    'Calculate Emissions',
                    () {
                      // Navigation...
                    },
                  ),
                  const SizedBox(width: 20.0),
                  _buildSquareButton(
                    Icons.shopping_cart,
                    'Procurement',
                    () {
                      // Navigation...
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProcurementPage()));
                    },
                  ), 
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSquareButton(
                    Icons.chat,
                    'Smart Chatbot',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatbotPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 20.0),
                  _buildSquareButton(
                    Icons.person,
                    'View Profile',
                    () {
                      // Navigate to profile screen
                      // Example:
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareButton(
    IconData icon, String label, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        height: 160.0,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(
            label,
            textAlign: TextAlign.center,
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Set button color to green
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(20.0),
          ),
        ),
      ),
    );
  }
}
