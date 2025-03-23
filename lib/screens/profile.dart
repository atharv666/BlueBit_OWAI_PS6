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
    String shortform = universalId != 'Sign Up/ Login to view details' ? createEmailShortForm(universalId) : '-';

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
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
                    shortform,
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
                  universalId,
                  style: TextStyle(
                    fontSize: universalId != 'Sign Up/ Login to view details' ? 24.0 : 16.0,
                    fontWeight: universalId != 'Sign Up/ Login to view details' ? FontWeight.bold : FontWeight.normal,
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
                  child: Text('Login/Signup'),
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
                          title: Text("Log Out?"),
                          content: Text(
                              "You will be signed out of the application. Do you really want to log out?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Yes"),
                            ),
                          ],
                        ),
                      );

                      if (shouldExit == true) {
                        await saveLoginStatus(false);
                        await saveIDStatus('Sign Up/ Login to view details');
                        universalId = 'Sign Up/ Login to view details';
                        logStatus = false;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()),
                          (route) => false,
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                    child: Text('Logout'),
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
