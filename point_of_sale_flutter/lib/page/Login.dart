import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/page/HomePageBananiBranch.dart';
import 'package:point_of_sale/page/LogoutPage.dart';
import 'package:point_of_sale/page/BranchProfile.dart';
import 'package:point_of_sale/page/HomePageDhanmondiBranch.dart';
import 'package:point_of_sale/page/Registration.dart';
import 'package:point_of_sale/page/Sales/CreateSalesBananiBranch.dart';
import 'package:point_of_sale/page/category/AllCategoryView.dart';
import 'package:point_of_sale/service/AuthService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController()..text = 'alammdtowhidul9@gmail.com';
  final TextEditingController password = TextEditingController()..text = '123456';
  final storage = FlutterSecureStorage();
  bool _isPasswordVisible = false;

  AuthService authService=AuthService();


  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);

      // Successful login, role-based navigation
      final  role =await authService.getUserRole(); // Get role from AuthService


      if (role == 'PHARMACIST') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreateSalesBananiBranch()),
        );
      } else if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (role == 'USER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageBananiBranc()),
        );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    }
  }


  // Future<void> loginUser(BuildContext context) async {
  //   final url = Uri.parse('http://localhost:8087/login');
  //
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email.text, 'password': password.text}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     final token = responseData['token'];
  //
  //     Map<String, dynamic> payload = Jwt.parseJwt(token);
  //     String sub = payload['sub'];
  //     String role = payload['role'];
  //
  //     await storage.write(key: 'token', value: token);
  //     await storage.write(key: 'sub', value: sub);
  //     await storage.write(key: 'role', value: role);
  //
  //     print('Login successful. Sub: $sub, Role: $role');
  //
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => Home()),
  //     );
  //   } else {
  //     print('Login failed with status: ${response.statusCode}');
  //     // Optionally show an error message
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.lightBlueAccent,
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(email, "Email", Icons.email),
                    SizedBox(height: 15),
                    _buildPasswordField(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        loginUser(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.lightGreenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationPage()),
                        );
                      },
                      child: Text(
                        'Registration',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust vertical padding for smaller height
        isDense: true, // Makes the text field more compact
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildPasswordField() {
    return TextField(


      controller: password,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
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
      style: TextStyle(color: Colors.white),
    );
  }
}
