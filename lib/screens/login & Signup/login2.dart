// import 'package:email_otp/email_otp.dart';
// import 'package:flutter/material.dart';
// import 'package:gmr/models/shared_preferences.dart';
// import 'package:gmr/screens/login%20&%20Signup/signup1.dart';
// import 'package:gmr/screens/login%20&%20Signup/success.dart';
// // import 'package:relieflink/shared_preferences.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

// class LoginScreen2 extends StatefulWidget {
//   const LoginScreen2({super.key, required this.email});

//   final String email;
//   @override
//   State<LoginScreen2> createState() => _LoginScreen2State();
// }

// class _LoginScreen2State extends State<LoginScreen2> {
//   final _form = GlobalKey<FormState>();

//   String _otp = '';

//   int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
//   bool _isResendEnabled = false;
//   late String _enteredEmail;

//   @override
//   void initState() {
//     super.initState();
//     _enteredEmail = widget.email; // Access email from the widget
//   }

//   void resendOTP() {
//     print("OTP Resent!");
//     EmailOTP.config(
//       appName: 'GMR (Generic Medicine Recommender)',
//       otpType: OTPType.numeric,
//       expiry: 60000,
//       emailTheme: EmailTheme.v6,
//       appEmail: 'atharv.rao23@pccoepune.org',
//       otpLength: 4,
//     );
//     EmailOTP.sendOTP(email: _enteredEmail);
//     setState(() {
//       _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
//       _isResendEnabled = false; // Disable button until countdown ends
//     });
//   }

//   void _submit() async {
//     //final isValid = _form.currentState!.validate();
  
//     if (EmailOTP.verifyOTP(otp: _otp)) {
//       await saveIDStatus(_enteredEmail);
//       universalId = _enteredEmail;
      
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (ctx) => const SuccessScreen(),
//         ),
//       );
//       return;
//     }
//     _form.currentState!.save();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       // onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor:const Color(0xFF2D7DD2),
//         // body: Container(
          
//           body: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
                  
//                   Card(
//                     margin: const EdgeInsets.all(20),
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Form(
//                           key: _form,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const SizedBox(height: 12),
//                               PinCodeTextField(
//                                 appContext: context,
//                                 length: 4, // OTP length
//                                 validator: (value) {
//                                   if (value == null ||
//                                       value.trim().length != 4) {
//                                     return 'Please enter a valid 4-digit OTP.';
//                                   }
//                                   return null;
//                                 },
//                                 onChanged: (value) {
//                                   _otp = value; // Save the entered OTP
//                                 },
//                                 keyboardType: TextInputType.number,
//                                 textStyle: const TextStyle(fontSize: 20),
//                                 pinTheme: PinTheme(
//                                   shape: PinCodeFieldShape.box,
//                                   borderRadius: BorderRadius.circular(5),
//                                   selectedColor: Colors.black,
//                                   activeColor:
//                                       const Color.fromARGB(255, 0, 0, 0),
//                                   inactiveColor:
//                                       const Color.fromARGB(255, 50, 100, 150),
//                                   fieldHeight: 50,
//                                   fieldWidth: 40,
//                                   activeFillColor: Colors.white,
//                                 ),
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                               ),
//                               _isResendEnabled
//                                   ? const Text("Didn't receive OTP?")
//                                   : CountdownTimer(
//                                       endTime: _endTime,
//                                       widgetBuilder: (_, time) {
//                                         if (time == null) {
//                                           // Use a post-frame callback to delay the state update
//                                           WidgetsBinding.instance
//                                               .addPostFrameCallback((_) {
//                                             setState(() {
//                                               _isResendEnabled = true;
//                                             });
//                                           });
//                                           return const Text(
//                                               "You can resend now");
//                                         }
//                                         return Text(
//                                             "Resend in ${time.sec} sec");
//                                       },
//                                     ),
//                               TextButton(
//                                 onPressed: _isResendEnabled ? resendOTP : null,
//                                 child: Text(
//                                   "Resend OTP",
//                                   style: TextStyle(
//                                     color: _isResendEnabled
//                                         ? Colors.blue
//                                         : Colors.grey,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               ElevatedButton(
//                                 onPressed: _submit,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 50, 100, 150),
//                                 ),
//                                 child: const Text(
//                                   'Login',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
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
//         // ),
//       ),
//     );
//   }
// }


import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:gmr/models/shared_preferences.dart';
import 'package:gmr/screens/login%20&%20Signup/signup1.dart';
import 'package:gmr/screens/login%20&%20Signup/success.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key, required this.email});

  final String email;
  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _form = GlobalKey<FormState>();

  String _otp = '';

  int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
  bool _isResendEnabled = false;
  late String _enteredEmail;

  @override
  void initState() {
    super.initState();
    _enteredEmail = widget.email;
  }

  void resendOTP() {
    print("OTP Resent!");
    EmailOTP.config(
      appName: 'GMR (Generic Medicine Recommender)',
      otpType: OTPType.numeric,
      expiry: 60000,
      emailTheme: EmailTheme.v6,
      appEmail: 'atharv.rao23@pccoepune.org',
      otpLength: 4,
    );
    EmailOTP.sendOTP(email: _enteredEmail);
    setState(() {
      _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
      _isResendEnabled = false;
    });
  }

  void _submit() async {
    if (EmailOTP.verifyOTP(otp: _otp)) {
      await saveIDStatus(_enteredEmail);
      universalId = _enteredEmail;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const SuccessScreen(),
        ),
      );
      return;
    }
    _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F2FD),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D7DD2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          PinCodeTextField(
                            appContext: context,
                            length: 4,
                            validator: (value) {
                              if (value == null || value.trim().length != 4) {
                                return 'Please enter a valid 4-digit OTP.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _otp = value;
                            },
                            keyboardType: TextInputType.number,
                            textStyle: const TextStyle(fontSize: 20),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              selectedColor: Colors.blueAccent,
                              activeColor: Colors.green,
                              inactiveColor: const Color(0xFF2D7DD2),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                            ),
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          _isResendEnabled
                              ? const Text("Didn't receive OTP?")
                              : CountdownTimer(
                                  endTime: _endTime,
                                  widgetBuilder: (_, time) {
                                    if (time == null) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          _isResendEnabled = true;
                                        });
                                      });
                                      return const Text("You can resend now");
                                    }
                                    return Text("Resend in ${time.sec} sec");
                                  },
                                ),
                          TextButton(
                            onPressed: _isResendEnabled ? resendOTP : null,
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                color: _isResendEnabled ? Colors.blue : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
