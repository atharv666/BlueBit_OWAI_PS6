import 'package:flutter/material.dart';
import 'package:gmr/screens/OCR.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Generic Recommender'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction Section
              Card(
                color: Colors.blue.shade50,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tired of expensive medicines?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Medical prescriptions often contain costly brand-name medicines, making healthcare difficult to afford. Our app helps you find generic alternatives that provide the same efficacy at a lower price.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'How it Works:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '1. Scan your prescription using our AI-powered scanner.\n2. Get instant suggestions for cost-effective generic alternatives.\n3. Compare prices and make informed healthcare decisions.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Scan Button Section
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text('Scan Prescription'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Ocr();
                    }));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
