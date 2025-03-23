import 'dart:io';
import 'package:flutter/material.dart';
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
  Future<Map<String, dynamic>>? medicineDataFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Recognition"),
        centerTitle: true,
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {
              selectedMedia = File(image.path);
              extractedText = null;
            });
            String? text = await _extractText(selectedMedia!);
            if (text != null && text.isNotEmpty) {
              setState(() {
                extractedText = text;
                // medicineDataFuture = getMedicineInfoFromDeepSeek(extractedText!);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("No text found in the image")),
              );
            }
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _imageView(),
        Divider(color: Colors.blueAccent),
        _extractTextView(),
        Divider(color: Colors.blueAccent),
        _medicineResultsView(),
      ],
    );
  }

  Widget _imageView() {
    return selectedMedia == null
        ? Center(child: Text("Pick an Image"))
        : Center(child: Image.file(selectedMedia!, width: 200));
  }

  Widget _extractTextView() {
    if (selectedMedia == null) return Center(child: Text("No Result"));
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(extractedText ?? "", style: TextStyle(fontSize: 25)),
      ),
    );
  }

  Widget _medicineResultsView() {
    return FutureBuilder<Map<String, dynamic>>(
      future: medicineDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!['medicines'] == null) {
          return Center(child: Text('No data available or invalid response'));
        }

        final medicines = snapshot.data!['medicines'] as List<dynamic>;
        if (medicines.isEmpty) {
          return Center(child: Text('No medicines found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(medicine['name'] ?? 'Unknown Medicine'),
                subtitle: Text(medicine['use'] ?? 'No information available'),
                children: [
                  ListTile(
                    title: Text("Composition: ${medicine['composition'] ?? 'Unknown'}"),
                    subtitle: Text("Price: ${medicine['price'] ?? 'Unknown'}"),
                  ),
                  if (medicine['alternatives'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Generic Alternatives:", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...?medicine['alternatives']?.map<Widget>((alt) => ListTile(
                              title: Text("${alt['name']} - ${alt['price']}"),
                              subtitle: Text("Composition: ${alt['composition']}"),
                            )),
                      ],
                    ),
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
