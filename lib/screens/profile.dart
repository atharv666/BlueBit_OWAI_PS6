import 'package:flutter/material.dart';
import 'package:gmr/screens/login%20&%20Signup/login1.dart';
import 'package:gmr/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool logStatus = false;
  String universalId = 'Sign Up/ Login to view details';

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load user data from SharedPreferences
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      universalId = prefs.getString('universalId') ?? 'Sign Up/ Login to view details';
      logStatus = prefs.getBool('logStatus') ?? false;
    });
  }

  String createEmailShortForm(String email) {
    if (email.length < 7) {
      return '-'; // Handle short emails safely
    }
    return '${email[0].toUpperCase()}${email[6].toUpperCase()}';
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logStatus', false);
    await prefs.setString('universalId', 'Sign Up/ Login to view details');

    setState(() {
      universalId = 'Sign Up/ Login to view details';
      logStatus = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String shortform = (universalId != 'Sign Up/ Login to view details')
        ? createEmailShortForm(universalId)
        : '-';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
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
                    fontWeight: universalId != 'Sign Up/ Login to view details'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Login Button
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
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Login/Signup',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Logout Button
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
                              child: const Text("No", style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Yes", style: TextStyle(color: Colors.green[700])),
                            ),
                          ],
                        ),
                      );

                      if (shouldExit == true) {
                        await logoutUser();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Logout', style: TextStyle(fontSize: 16)),
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
