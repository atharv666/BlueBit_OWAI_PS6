// import 'package:flutter/material.dart';
// import 'package:gmr/services/getmedicine.dart';

// class MedicineResultsScreen extends StatefulWidget {
//   final String extractedText; // Pass extracted prescription text

//   const MedicineResultsScreen({Key? key, required this.extractedText}) : super(key: key);

//   @override
//   _MedicineResultsScreenState createState() => _MedicineResultsScreenState();
// }

// class _MedicineResultsScreenState extends State<MedicineResultsScreen> {
//   Future<Map<String, dynamic>>? medicineDataFuture;

//   @override
//   void initState() {
//     super.initState();
//     // Trigger API call
//     medicineDataFuture = getMedicineInfoFromGemini(widget.extractedText);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medicine Information")),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: medicineDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available'));
//           }

//           final medicines = snapshot.data!['medicines'] as List<dynamic>;

//           return ListView.builder(
//             itemCount: medicines.length,
//             itemBuilder: (context, index) {
//               final medicine = medicines[index];
//               return Card(
//                 margin: EdgeInsets.all(8.0),
//                 child: ExpansionTile(
//                   title: Text(medicine['name']),
//                   subtitle: Text(medicine['use']),
//                   children: [
//                     ListTile(
//                       title: Text("Composition: ${medicine['composition']}"),
//                       subtitle: Text("Price: ${medicine['price']}"),
//                     ),
//                     Text("Generic Alternatives:", style: TextStyle(fontWeight: FontWeight.bold)),
//                     ...medicine['alternatives'].map<Widget>((alt) => ListTile(
//                           title: Text("${alt['name']} - ${alt['price']}"),
//                           subtitle: Text("Composition: ${alt['composition']}"),
//                         )),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
