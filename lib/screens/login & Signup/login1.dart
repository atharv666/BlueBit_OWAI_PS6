// import 'dart:convert';

// import 'package:email_otp/email_otp.dart';
// import 'package:flutter/material.dart';
// import 'package:gmr/screens/login%20&%20Signup/login2.dart';
// import 'package:gmr/screens/login%20&%20Signup/signup1.dart';

// import 'package:http/http.dart' as http;

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _form = GlobalKey<FormState>();
//   var _enteredEmail = '';
//   // ignore: unused_field
//   final _enteredPassword = '';
//   // ignore: unused_field
//   final _isLogin = true;

//   void _submit() async {
//     final isValid = _form.currentState!.validate();

//     if (!isValid) {
//       return;
//     }
//     _form.currentState!.save();

//     bool shouldSend = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Send OTP?"),
//         content: Text(
//             "Do you want to send the OTP(One Time Password) to $_enteredEmail?"),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: Text("No")),
//           TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: Text("Yes")),
//         ],
//       ),
//     );

//     if (shouldSend == true) {
//       if (await verifyIfAccExists(_enteredEmail) == true) {
//         sendOTP(_enteredEmail);
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//               builder: (context) => LoginScreen2(
//                     email: _enteredEmail,
//                   )),
//           (route) => false, // This removes all previous screens
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Email not registered. Please Sign Up.")),
//         );
//       }
//     }
//   }

//   Future<bool> verifyIfAccExists(String email) async {
//   final Uri url = Uri.https(
//     "gmrapp-4da95-default-rtdb.firebaseio.com",
//     "users.json",
//   ); 

//   bool emailFound = false;

//   try {
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic>? users = json.decode(response.body);
//       if (users != null) {
//         for (var entry in users.entries) {
//           var user = entry.value;
//           if (user['email'] != null &&
//               user['email'].toString().trim().toLowerCase() ==
//                   email.trim().toLowerCase()) {
//             print('Email found in users.json ✅');
//             emailFound = true;
//           }
//         }
//       }
//     } else {
//       print("Failed to fetch users data: ${response.statusCode}");
//     }

//     if (!emailFound) {
//       print('Email NOT found ❌');
//     }

//     return emailFound;
//   } catch (error) {
//     print("Error: $error");
//     return false;
//   }
// }


//   void sendOTP(String email) {
//     EmailOTP.config(
//       appName: 'GMR (Generic Medicine Recommender)',
//       otpType: OTPType.numeric,
//       expiry: 600000,
//       emailTheme: EmailTheme.v6,
//       appEmail: 'support@GMR.com',
//       otpLength: 4,
//     );

//     print(email);
//     EmailOTP.sendOTP(email: email);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color(0xFF2D7DD2),
//         extendBody: true,
//         body: Container(
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Card(
//                     color: Colors.white,
//                     margin: const EdgeInsets.all(20),
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Form(
//                           key: _form,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               TextFormField(
//                                 decoration: const InputDecoration(
//                                     labelText: 'Email Address'),
//                                 keyboardType: TextInputType.emailAddress,
//                                 autocorrect: false,
//                                 textCapitalization: TextCapitalization.none,
//                                 validator: (value) {
//                                   if (value == null ||
//                                       value.trim().isEmpty ||
//                                       !value.contains('@')) {
//                                     return 'Please enter a valid email address.';
//                                   }

//                                   return null;
//                                 },
//                                 onSaved: (value) {
//                                   _enteredEmail = value!;
//                                   print(_enteredEmail);
//                                 },
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   _submit();
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 50, 100, 150),
//                                 ),
//                                 child: const Text(
//                                   'Send OTP',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (ctx) => const SignUpScreen(),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text(
//                                   'Create an account',
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:gmr/screens/login%20&%20Signup/login2.dart';
import 'package:gmr/screens/login%20&%20Signup/signup1.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  final _enteredPassword = '';
  final _isLogin = true;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    bool shouldSend = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Send OTP?"),
        content: Text(
            "Do you want to send the OTP(One Time Password) to $_enteredEmail?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Yes")),
        ],
      ),
    );

    if (shouldSend == true) {
      if (await verifyIfAccExists(_enteredEmail) == true) {
        sendOTP(_enteredEmail);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen2(
                    email: _enteredEmail,
                  )),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Email not registered. Please Sign Up.")),
        );
      }
    }
  }

  Future<bool> verifyIfAccExists(String email) async {
    final Uri url = Uri.https(
      "gmrapp-4da95-default-rtdb.firebaseio.com",
      "users.json",
    );

    bool emailFound = false;

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
              print('Email found in users.json ✅');
              emailFound = true;
            }
          }
        }
      } else {
        print("Failed to fetch users data: ${response.statusCode}");
      }

      if (!emailFound) {
        print('Email NOT found ❌');
      }

      return emailFound;
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }

  void sendOTP(String email) {
    EmailOTP.config(
      appName: 'GMR (Generic Medicine Recommender)',
      otpType: OTPType.numeric,
      expiry: 600000,
      emailTheme: EmailTheme.v6,
      appEmail: 'support@GMR.com',
      otpLength: 4,
    );

    print(email);
    EmailOTP.sendOTP(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F2FD),
        extendBody: true,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Welcome to GMR',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D7DD2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Create an account',
                              style: TextStyle(color: Color(0xFF2D7DD2)),
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
        ),
      ),
    );
  }
}
