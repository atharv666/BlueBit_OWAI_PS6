import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gmr/models/medicine.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Ocr extends StatefulWidget {
  const Ocr({super.key});

  @override
  State<Ocr> createState() => _OcrState();
}

class _OcrState extends State<Ocr> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();
  String? extractedText;
  Future<List<Map<String, dynamic>>>? medicineDataFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Recognition"),
        centerTitle: true,
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedMedia = File(image.path);
        extractedText = null;
        medicineDataFuture = null;
      });
      String? text = await _extractText(selectedMedia!);
      if (text != null && text.isNotEmpty) {
        setState(() {
          extractedText = text;
          medicineDataFuture = GeminiService.extractAndGetMedicineDetails(text);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No text found in the image")),
        );
      }
    }
  }

  Widget _buildUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _imageView(),
        Divider(color: Colors.blueAccent),
        _extractTextView(),
        Divider(color: Colors.blueAccent),
        Expanded(child: _medicineResultsView()),
      ],
    );
  }

  Widget _imageView() {
    return selectedMedia == null
        ? Center(child: Text("Pick an Image"))
        : Center(child: Image.file(selectedMedia!, width: 200));
  }

  Widget _extractTextView() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(extractedText ?? "No Extracted Text", style: TextStyle(fontSize: 25)),
      ),
    );
  }

  // Widget _medicineResultsView() {
  //   return FutureBuilder<List<Map<String, dynamic>>>(
  //     future: medicineDataFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
  //         return Center(child: Text('Failed to fetch data or no medicine details available.'));
  //       }

  //       final medicines = snapshot.data!;
  //       return ListView.builder(
  //         itemCount: medicines.length,
  //         itemBuilder: (context, index) {
  //           final medicine = medicines[index];
  //           return Card(
  //             margin: EdgeInsets.all(8.0),
  //             child: ExpansionTile(
  //               title: Text(medicine['Title']?.toString() ?? 'Unknown Medicine'),
  //               subtitle: Text(medicine['Description']?.toString() ?? 'No information available'),
  //               children: [
  //                 ListTile(
  //                   title: Text("Manufacturer: ${medicine['Manufacturer']?.toString() ?? 'Unknown'}"),
  //                   subtitle: Text("Composition: ${medicine['Composition']?.toString() ?? 'Unknown'} | Price: ${medicine['Price']?.toString() ?? 'Unknown'}"),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  Widget _medicineResultsView() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: medicineDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('Failed to fetch data or no medicine details available.'));
        }

        final medicines = snapshot.data!;
        return ListView.builder(
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            final alternatives = (medicine['Alternatives'] as List?) ?? [];

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(medicine['Title']?.toString() ?? 'Unknown Medicine'),
                subtitle: Text(medicine['Description']?.toString() ?? 'No information available'),
                children: [
                  ListTile(
                    title: Text("Manufacturer: ${medicine['Manufacturer']?.toString() ?? 'Unknown'}"),
                    subtitle: Text("Composition: ${medicine['Composition']?.toString() ?? 'Unknown'} | Price: ${medicine['Price']?.toString() ?? 'Unknown'}"),
                  ),
                  if (alternatives.isNotEmpty)
                    Column(
                      children: alternatives.map((alt) {
                        return ListTile(
                          title: Text("Alternative: ${alt['Title'] ?? 'Unknown'}"),
                          subtitle: Text("Price: ${alt['Price'] ?? 'Unknown'} | Composition: ${alt['Composition'] ?? 'Unknown'}"),
                        );
                      }).toList(),
                    )
                  else
                    ListTile(title: Text("No Alternatives Available"))
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return recognizedText.text;
  }
}
