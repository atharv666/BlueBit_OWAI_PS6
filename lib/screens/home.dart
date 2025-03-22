import 'package:flutter/material.dart';
import 'package:gmr/screens/OCR.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent
              ),
              child: Icon(Icons.camera, color: Colors.white,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Ocr();
                },));
              },
            ),
          ),
        ],
      ),
    );
  }
}