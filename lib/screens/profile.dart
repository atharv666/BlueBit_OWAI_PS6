// import 'package:flutter/material.dart';
// import 'package:gmr/models/shared_preferences.dart';
// import 'package:gmr/screens/login%20&%20Signup/login1.dart';
// import 'package:gmr/screens/splash.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   String createEmailShortForm(String email) {
//     if (email.length < 7) {
//       throw FormatException('Email should have at least 7 characters');
//     }
//     return '${email[0].toUpperCase()}${email[6].toUpperCase()}';
//   }


//   @override
//   Widget build(BuildContext context) {
//     String shortform = createEmailShortForm(universalId);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               // Navigate to settings
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Visibility(
//                 visible: !logStatus,
//                 child: const SizedBox(height: 120.0),
//               ),
//               const SizedBox(height: 16.0),
//               Center(
//                 child: CircleAvatar(
//                   radius: 50.0,
//                   backgroundColor: Colors.blue,
//                   child: Text(
//                     (universalId != 'Sign Up/ Login to view details')
//                         ? shortform
//                         : '-',
//                     style: const TextStyle(
//                       fontSize: 32.0,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               Center(
//                 child: Text(
//                   (universalId != 'Sign Up/ Login to view details')
//                       ? universalId
//                       : 'Sign Up/ Login to view details',
//                   style: TextStyle(
//                     fontSize: (universalId != 'Sign Up/ Login to view details')
//                         ? 24.0
//                         : 16.0,
//                     fontWeight:
//                         (universalId != 'Sign Up/ Login to view details')
//                             ? FontWeight.bold
//                             : FontWeight.normal,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Visibility(
//                 visible: universalId == 'Sign Up/ Login to view details',
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (ctx) => const LoginScreen()),
//                     );
//                   },
//                   child: Text('Login/Signup'),
//                 ),
//               ),
//               const SizedBox(height: 24.0),

//               // Logout button
//               Visibility(
//                 visible: logStatus,
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     onPressed: () async {
//                       bool shouldExit = await showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: Text("Log Out?"),
//                           content: Text(
//                               "You will be signed out of the application. Do you really want to log out?"
//                               ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.of(context).pop(false),
//                               child: Text("No"),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.of(context).pop(true),
//                               child: Text("Yes"),
//                             ),
//                           ],
//                         ),
//                       );

//                       if (shouldExit == true) {
//                         await saveLoginStatus(false);
//                         await saveIDStatus('Sign Up/ Login to view details');
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => SplashScreen()),
//                           (route) => false,
//                         );
//                       }
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.red),
//                       foregroundColor: Colors.red,
//                     ),
//                     child: Text('Logout'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24.0),
//             ],
//           ),
//         ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gmr/models/shared_preferences.dart';
import 'package:gmr/screens/login%20&%20Signup/login1.dart';
import 'package:gmr/screens/splash.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String createEmailShortForm(String email) {
    if (email.length < 7) {
      throw FormatException('Email should have at least 7 characters');
    }
    return '${email[0].toUpperCase()}${email[6].toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    String shortform = createEmailShortForm(universalId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: !logStatus,
                child: const SizedBox(height: 120.0),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.blue,
                  child: Text(
                    (universalId != 'Sign Up/ Login to view details')
                        ? shortform
                        : '-',
                    style: const TextStyle(
                      fontSize: 32.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Text(
                  (universalId != 'Sign Up/ Login to view details')
                      ? universalId
                      : 'Sign Up/ Login to view details',
                  style: TextStyle(
                    fontSize: (universalId != 'Sign Up/ Login to view details')
                        ? 24.0
                        : 16.0,
                    fontWeight:
                        (universalId != 'Sign Up/ Login to view details')
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Visibility(
                visible: universalId == 'Sign Up/ Login to view details',
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Login/Signup',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Logout button
              Visibility(
                visible: logStatus,
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      bool shouldExit = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Log Out?", style: TextStyle(color: Colors.blue[800])),
                          content: Text(
                            "You will be signed out of the application. Do you really want to log out?",
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("No", style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Yes", style: TextStyle(color: Colors.green[700])),
                            ),
                          ],
                        ),
                      );

                      if (shouldExit == true) {
                        await saveLoginStatus(false);
                        await saveIDStatus('Sign Up/ Login to view details');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()),
                          (route) => false,
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Logout', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}