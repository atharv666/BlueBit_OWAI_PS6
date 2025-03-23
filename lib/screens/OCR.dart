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
        title: const Text("Text Recognition", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("📸 Selected Image", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ),
            Expanded(flex: 2, child: _imageView()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("📝 Extracted Text", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
            ),
            Expanded(flex: 1, child: _extractTextView()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("💊 Medicine Results", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ),
            Expanded(flex: 3, child: _medicineResultsView()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
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
          const SnackBar(content: Text("No text found in the image")),
        );
      }
    }
  }

  Widget _imageView() {
    return selectedMedia == null
        ? const Center(
            child: Text("Pick an Image", style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
          )
        : Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.file(selectedMedia!, width: 300, height: 300, fit: BoxFit.cover),
            ),
          );
  }

  Widget _extractTextView() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))
        ],
      ),
      child: SingleChildScrollView(
        child: Text(
          extractedText ?? "No Extracted Text",
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _medicineResultsView() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: medicineDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('Failed to fetch data or no medicine details available.'));
        }

        final medicines = snapshot.data!;
        return ListView.builder(
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            final alternatives = (medicine['Alternatives'] as List?) ?? [];

            return Card(
              color: Colors.white,
              elevation: 6,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Text(
                  medicine['Title']?.toString() ?? 'Unknown Medicine',
                  style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(medicine['Description']?.toString() ?? 'No information available'),
                children: [
                  ListTile(
                    title: Text("Manufacturer: ${medicine['Manufacturer']?.toString() ?? 'Unknown'}"),
                    subtitle: Text(
                        "Composition: ${medicine['Composition']?.toString() ?? 'Unknown'} | Price: ${medicine['Price']?.toString() ?? 'Unknown'}"),
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
                    const ListTile(title: Text("No Alternatives Available"))
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
