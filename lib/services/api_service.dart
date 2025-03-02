import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> sendQuizResponses(List<int> answers, String openAnswer) async {
    final String apiUrl = "http://localhost:5000/predict"; // Mets l'URL de ton backend

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "answers": [answers], // Format conforme à ton backend
          "openAnswer": openAnswer
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de l'envoi des réponses : $e");
    }
  }
}
