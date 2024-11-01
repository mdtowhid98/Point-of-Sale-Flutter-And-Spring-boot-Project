import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_first_class/page/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  String? selectedGender;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dob.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _registration() async {
    if (_formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        _showMessage("Passwords do not match");
        return;
      }

      setState(() {
        _isLoading = true;
      });

      String uName = name.text;
      String uEmail = email.text;
      String uPassword = password.text;
      String uCell = cell.text;
      String uAddress = address.text;
      String uDob = dob.text;
      String uGender = selectedGender ?? 'Others';

      final response = await _sendDataToBackend(
          uName, uEmail, uPassword, uCell, uAddress, uGender, uDob);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showMessage("Registration Successful");
      } else if (response.statusCode == 409) {
        _showMessage("User already exists!");
      } else {
        _showMessage("Registration failed with status: ${response.statusCode}");
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String name, String email, String password, String cell, String address, String gender, String dob) async {
    const String url = 'http://localhost:8087/register';

    return await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'cell': cell,
        'address': address,
        'gender': gender,
        'dob': dob,
      }),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value!.isEmpty ? "Please enter your name" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? "Please enter your email" : null,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Gender: "),
                    Radio<String>(
                      value: "Male",
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text("Male"),
                    Radio<String>(
                      value: "Female",
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text("Female"),
                    Radio<String>(
                      value: "Others",
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text("Others"),
                  ],
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: cell,
                  decoration: InputDecoration(
                    labelText: "Cell No",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? "Please enter your cell number" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: dob,
                  decoration: InputDecoration(
                    labelText: "Date Of Birth",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: address,
                  decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) => value!.isEmpty ? "Please enter your address" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? "Please enter your password" : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: confirmPassword,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? "Please confirm your password" : null,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _registration,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightGreenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.lightGreenAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
