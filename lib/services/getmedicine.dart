// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<Map<String, dynamic>> getMedicineInfoFromGemini(String extractedText) async {
//   const String apiKey = 'AIzaSyCgvrjIFVH2dbSDz0r2JpWdmkJezKdMdCY';
//   const String apiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=$apiKey';

//   // Craft a detailed prompt for Gemini
//   String prompt = '''
//   Here is the extracted prescription text: "$extractedText".
//   1. Identify the medicine names from the text.
//   2. Provide information on what these medicines are used for, their composition, manufacturer and their current prices.
//   3. Suggest generic alternatives with their names, compositions, prices, and primary uses.
//   Provide results in a structured JSON format.
//   ''';

//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'contents': [
//         {'parts': [{'text': prompt}]}
//       ]
//     }),
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception('Failed to get data from Gemini: ${response.body}');
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getMedicineInfoFromDeepSeek(String extractedText) async {
  const String apiKey = 'sk-16747b9a7eb746139793932294b6318d'; // Replace with your actual API key
  const String apiUrl = "https://api.deepseek.com/v1/medicines/search";

  // Craft a clear prompt
  String prompt = '''
  I have a prescription with the following extracted text: "$extractedText".
  1. Identify the medicine names mentioned in the text.
  2. Provide information about these medicines, including their uses, composition, manufacturer, and current market prices.
  3. Suggest generic alternatives, along with their names, compositions, prices, and primary uses.
  Ensure the response is in a clean and structured JSON format like this:

  {
    "medicines": [
      {
        "name": "Medicine Name",
        "use": "Primary Use",
        "composition": "Active Ingredients",
        "manufacturer": "Company Name",
        "price": "Current Market Price",
        "alternatives": [
          {
            "name": "Generic Alternative 1",
            "composition": "Ingredients",
            "price": "Alternative Price",
            "use": "Primary Use"
          }
        ]
      }
    ]
  }
  Provide accurate data only. If no data is available, respond with "Sorry No Generic Alternatives available".
  ''';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'deepseek-chat', // Use appropriate DeepSeek model if applicable
      'messages': [
        {'role': 'system', 'content': 'You are a medical assistant.'},
        {'role': 'user', 'content': prompt}
      ]
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to get data from DeepSeek: ${response.body}');
  }
}
