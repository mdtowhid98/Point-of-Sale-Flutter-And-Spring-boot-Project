import 'package:flutter/material.dart';
import 'package:point_of_sale/page/Login.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hides the back button
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.yellowAccent, Colors.lightGreenAccent], // Mixed colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        // Full-screen gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.yellowAccent, Colors.lightGreenAccent], // Mixed colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally
            children: [
              // Display the image at the top
              Image.network(
                'https://cdn-icons-png.flaticon.com/128/1828/1828490.png',
                width: 80, // Set the width of the image
                height: 80, // Set the height of the image
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'You have successfully logged out!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: const Text('Go to Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,// Background color of the button
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0), // Increased padding
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600, // Slightly bolder text
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
