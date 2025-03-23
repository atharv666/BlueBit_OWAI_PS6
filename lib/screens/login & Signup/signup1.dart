import 'dart:convert';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:gmr/models/shared_preferences.dart';
import 'package:gmr/models/users.dart';
import 'package:gmr/screens/home.dart';
import 'package:gmr/screens/login%20&%20Signup/login1.dart';
import 'package:gmr/screens/login%20&%20Signup/signup2.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredFirstName = '';
  String _enteredLastName = '';
  String _enteredContact = '';
  String _enteredLocation = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    bool shouldSend = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Send OTP?"),
        content: Text("Do you want to send the OTP to $_enteredEmail?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes")),
        ],
      ),
    );
    if (shouldSend == true) {
      if (await verifyIfAccExists(_enteredEmail) == false) {
        sendOTP();
        final user = Users(
          email: _enteredEmail,
          firstName: _enteredFirstName,
          lastName: _enteredLastName,
          contact: _enteredContact,
          location: _enteredLocation,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SignUpScreen2(
                    email: _enteredEmail,
                    users: user,
                  )),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Email already registered. Please log in.")),
        );
      }
    }
  }

  void sendOTP() {
    EmailOTP.config(
      appName: 'GMR (Generic Medicine Recommender)',
      otpType: OTPType.numeric,
      expiry: 60000,
      emailTheme: EmailTheme.v6,
      appEmail: 'support@GMR.com',
      otpLength: 4,
    );

    EmailOTP.sendOTP(email: _enteredEmail);
  }

  Future<bool> verifyIfAccExists(String email) async {
    final Uri url =
        Uri.http("gmrapp-4da95-default-rtdb.firebaseio.com", "users.json");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic>? users = json.decode(response.body);
        if (users != null) {
          for (var entry in users.entries) {
            var user = entry.value;
            if (user['email'] != null &&
                user['email'].toString().trim().toLowerCase() ==
                    email.trim().toLowerCase()) {
              return true;
            }
          }
        }
      } else {
        print("Failed to fetch data: \${response.statusCode}");
      }
    } catch (error) {
      print("Error: \$error");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F2FD), // Light blue background
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          const Text(
                            'Sign Up for Medicine Recommender',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D7DD2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField('Email Address', Icons.email, (value) {
                            _enteredEmail = value!;
                          }, (value) => value!.contains('@') ? null : 'Invalid email'),
                          _buildTextField('First Name', Icons.person, (value) {
                            _enteredFirstName = value!;
                          }, null),
                          _buildTextField('Last Name', Icons.person_outline, (value) {
                            _enteredLastName = value!;
                          }, null),
                          _buildTextField('Contact Number', Icons.phone, (value) {
                            _enteredContact = value!;
                          }, null),
                          _buildTextField('Location', Icons.location_on, (value) {
                            _enteredLocation = value!;
                          }, null),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50), // Green
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                            ),
                            child: const Text('Send OTP', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {},
                            child: const Text('I already have an Account', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
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

  Widget _buildTextField(String label, IconData icon, Function(String?) onSaved, String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF2D7DD2)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF2D7DD2), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: label == 'Contact Number' ? TextInputType.phone : TextInputType.text,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
