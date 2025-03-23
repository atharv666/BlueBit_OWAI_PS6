import 'package:flutter/material.dart';
import 'package:gmr/screens/OCR.dart';
import 'package:gmr/screens/forum.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isForumExpanded = false;
  bool isScanExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Generic Recommender'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💊 Branded Medicines are Costly!',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'We understand how expensive medical prescriptions can be. Branded medicines often come with heavy price tags.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '🟢 Our Solution',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          Text(
                            'Generic Recommender helps you find cost-effective generic alternatives to branded medicines, providing the same efficacy at a much lower price.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🌟 Why Choose Us?',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          _buildFeatureRow('Prescription Scanner', 'Scan prescriptions and get instant generic alternatives using AI.'),
                          _buildFeatureRow('Multilingual Support', 'Access our services in your preferred language.'),
                          _buildFeatureRow('Accurate Alternatives', 'Get reliable suggestions for generic medicines with detailed insights.'),
                          _buildFeatureRow('Price Comparison', 'Compare medicine prices to save on medical expenses.'),
                          _buildFeatureRow('Composition & Manufacturer Info', 'Get complete details on ingredients and manufacturers.'),
                          _buildFeatureRow('Community Forum', 'Engage in discussions and get advice from others.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Buttons using Stack with Expand Animation
          Positioned(
            right: 20,
            bottom: 80,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: isForumExpanded ? 180 : 56,
              child: FloatingActionButton.extended(
                onPressed: () {
                  if (isForumExpanded) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return CommunityForum();
                    },)).then((_){
                      setState(() {
                        isForumExpanded = false;
                      });
                    });
                  } else {
                    setState(() => isForumExpanded = true);
                  }
                },
                label: isForumExpanded ? Text('Join Forum') : SizedBox.shrink(),
                icon: Center(child: Icon(Icons.forum)),
                backgroundColor: Colors.green,
                heroTag: "joinForumButton",
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: isScanExpanded ? 210 : 56,
              child: FloatingActionButton.extended(
                onPressed: () {
                  if (isScanExpanded) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Ocr())).then((_) {
                      setState(() => isScanExpanded = false);
                    });
                  } else {
                    setState(() => isScanExpanded = true);
                  }
                },
                label: isScanExpanded ? Text('Scan Prescription') : SizedBox.shrink(),
                icon: Icon(Icons.camera_alt),
                backgroundColor: Colors.blueAccent,
                heroTag: "scanPrescriptionButton",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
