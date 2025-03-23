import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyAYUkKQ0zEk37B0LGlx1qKiadVcW94RTpA"; // Replace with your API key
  static const String model = "gemini-1.5-pro";
  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1/models/$model:generateContent?key=$apiKey";

  static Future<String> generateText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
            "No response from Gemini API.";
      } else {
        return "API Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<List<Map<String, dynamic>>> extractAndGetMedicineDetails(String rawText) async {
    final prompt = """
      You will be given a raw text. First, extract the medicine names from it. Then provide the following details for each medicine:
      - Title
      - Description (What it does)
      - Manufacturer
      - Composition
      - Price (in local currency if possible)
      - Side Effects
      - Alternatives (List of alternative medicines with prices, composition, and side effects if any)
      Provide the response in JSON format. If no valid data is available, respond with []
      Here is the raw text: "$rawText"
    """;

    try {
      String result = await generateText(prompt);

      result = result.replaceAll('```json', '').replaceAll('```', '').replaceAll(RegExp(r'//.*'), '').trim();

      if (result.startsWith('[')) {
        return List<Map<String, dynamic>>.from(jsonDecode(result));
      } else {
        throw FormatException("Invalid JSON response: $result");
      }
    } catch (e) {
      print("Error extracting medicine details: $e");
      return [];
    }
  }
}
