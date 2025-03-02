import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String flaskApiUrl =
      "http://10.0.2.2:5000/predict"; 

  // 📌 Fonction pour envoyer les réponses du quiz
  static Future<Map<String, dynamic>> sendQuizResults(
      List<String> answers, String openAnswer) async {
    try {
      // 📌 Convertir les réponses en valeurs numériques
      List<int> numericAnswers = answers.map((answer) {
        if (["Jamais", "Parfois", "Souvent", "Toujours"].contains(answer)) {
          switch (answer) {
            case "Jamais":
              return 0;
            case "Parfois":
              return 1;
            case "Souvent":
              return 2;
            case "Toujours":
              return 3;
            default:
              return 0;
          }
        } else if (["Pas du tout", "Légèrement", "Moyennement", "Beaucoup"]
            .contains(answer)) {
          switch (answer) {
            case "Pas du tout":
              return 0;
            case "Légèrement":
              return 1;
            case "Moyennement":
              return 2;
            case "Beaucoup":
              return 3;
            default:
              return 0;
          }
        }
        return 0;
      }).toList();

      // 📌 Vérifier et s'assurer que `answers` a EXACTEMENT 14 éléments
      if (numericAnswers.length > 14) {
        numericAnswers =
            numericAnswers.sublist(0, 14); // Prendre les 14 premières réponses
      }
      if (numericAnswers.length < 14) {
        while (numericAnswers.length < 14) {
          numericAnswers.add(0); // Compléter avec 0 si manque de valeurs
        }
      }

      // 📌 Construire la requête JSON
      Map<String, dynamic> requestBody = {
        "answers": numericAnswers,
        "openAnswer": openAnswer,
      };

      print("📤 Envoi des réponses : $requestBody");

      var response = await http.post(
        Uri.parse(flaskApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("📥 Réponse du backend : ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          "category": data["category"] ?? "Unknown",
          "score": data["score"] ?? 0.0
        };
      } else {
        throw Exception("Erreur serveur");
      }
    } catch (e) {
      throw Exception("Erreur connexion: $e");
    }
  }
}
