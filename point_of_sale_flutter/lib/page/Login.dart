import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/page/ErrorPage.dart';
import 'package:point_of_sale/page/HomePageBananiBranch.dart';
import 'package:point_of_sale/page/HomePageDhanmondiBranch.dart';
import 'package:point_of_sale/page/Registration.dart';
import 'package:point_of_sale/page/Sales/CreateSalesBananiBranch.dart';
import 'package:point_of_sale/service/AuthService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final TextEditingController email = TextEditingController()..text = 'alammdtowhidul9@gmail.com';
  // final TextEditingController password = TextEditingController()..text = '123456';

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final storage = FlutterSecureStorage();
  bool _isPasswordVisible = false;
  bool isLoading = false;

  AuthService authService = AuthService();

  Future<void> loginUser(BuildContext context) async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final response = await authService.login(email.text, password.text);

      // Successful login, role-based navigation
      final role = await authService.getUserRole(); // Get role from AuthService

      if (role == 'PHARMACIST') {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => CreateSalesBananiBranch()),
        // );
      } else if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (role == 'USER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageBananiBranch()),
        );
      }

      else {
        // print('Unknown role: $role');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Errorpage()),
        );
      }
    } catch (error) {
      print('Login failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0), // Apply padding of 10 on all sides
                  child: Image.network(
                    'https://i.postimg.cc/sXCZ47RM/woman-self-kiosk-checkout-payment-store-107791-30537.png',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Card(
                    color: Colors.lightGreenAccent, // Set the background color to amber
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login",
                            style: GoogleFonts.lato(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField(email, "Email", Icons.email),
                          SizedBox(height: 15),
                          _buildPasswordField(),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : () => loginUser(context),
                            child: Text(
                              isLoading ? "Please wait..." : "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Makes the text bold
                                color: Colors.black,         // Sets the font color to black

                              ),
                            ),

                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegistrationPage()),
                              );
                            },
                            child: Text(
                              'Registration',
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading spinner
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
        contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust vertical padding for smaller height
        isDense: true, // Makes the text field more compact
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: password,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust vertical padding for smaller height
        isDense: true, // Makes the text field more compact
      ),
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: Colors.black),
    );
  }
}
