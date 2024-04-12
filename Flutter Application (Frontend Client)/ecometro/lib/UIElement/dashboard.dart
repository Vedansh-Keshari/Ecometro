import 'package:flutter/material.dart';

class DashboardUI extends StatelessWidget {
  final String userName; // User's name

  // Placeholder user stats
  final double co2Saved = 150.0; // Example value for CO2 saved
  final double co2Goal = 500.0; // Example value for CO2 goal

  const DashboardUI({Key? key, required this.userName}) : super(key: key);

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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProcurementPage()));
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
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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

              // CO2 Emissions Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CO2 Emissions',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Saved: $co2Saved kg', // Display CO2 saved
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Goal: $co2Goal kg', // Display CO2 goal
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 10.0),
                      LinearProgressIndicator(
                        value: co2Saved / co2Goal, // Calculate progress
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Other Widgets...
            ],
          ),
        ),
      ),
    );
  }
}
