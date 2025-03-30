import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      "http://10.0.2.2:3000/api/quiz"; // 🔹 API locale

  /// 📌 **Envoyer les réponses et récupérer la prédiction**
  static Future<Map<String, dynamic>> sendQuizResults(
      List<String> answers, String patientId) async {
    try {
      List<int> numericAnswers = answers.map((answer) {
        switch (answer) {
          case "Jamais":
          case "Pas du tout":
            return 0;
          case "Parfois":
          case "Légèrement":
            return 1;
          case "Souvent":
          case "Moyennement":
            return 2;
          case "Toujours":
          case "Beaucoup":
            return 3;
          default:
            return 0;
        }
      }).toList();

      Map<String, dynamic> requestBody = {
        "patient_id": patientId,
        "answers": numericAnswers,
      };

      print("📤 Envoi des réponses : $requestBody");

      var response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("📥 Réponse API : ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (!data.containsKey("result")) {
          throw Exception("❌ Réponse invalide !");
        }

        return {
          "niveau_anxiete": data["result"]["niveau_anxiete"] ?? "Inconnu",
          "score": (data["result"]["score_anxiete"] ?? 0).toDouble(),
        };
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Erreur connexion : $e");
      throw Exception("Erreur connexion: $e");
    }
  }

  /// 📌 **Récupérer l'historique des tests**
  static Future<List<Map<String, dynamic>>> fetchHistory(
      String patientId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/history/$patientId"),
        headers: {"Content-Type": "application/json"},
      );

      print("📥 Réponse API historique : ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(
            "Erreur chargement historique : ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Erreur connexion : $e");
      throw Exception("Erreur connexion: $e");
    }
  }
}
