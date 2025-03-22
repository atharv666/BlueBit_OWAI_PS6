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
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imageView(),
        _extractTextView(),
      ],
    );
  }

  Widget _imageView() {
    if (selectedMedia == null) {
      return Center(child: Text("Pick an Image"));
    }
    return Center(
      child: Image.file(selectedMedia!, width: 200),
    );
  }

  Widget _extractTextView(){
    if(selectedMedia == null){
      return Center(child: Text("No Result"),);
    }
    return Expanded(
      child: FutureBuilder(future: _extractText(selectedMedia!), builder: (context, snapshot) {
        return SingleChildScrollView(scrollDirection: Axis.vertical,child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(snapshot.data ?? "", style: TextStyle(fontSize: 25),),
        ));
      },),
    );
  }

  Future<String?>_extractText(File file)async{
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }
}
