import 'package:flutter/material.dart';
import 'HistoryPage.dart';

class ResultPage extends StatelessWidget {
  final String patientId;
  final String category;
  final double score;

  const ResultPage({
    required this.patientId,
    required this.category,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    print("📌 Affichage des résultats : $category, Score : $score");

    return Scaffold(
      appBar: AppBar(title: Text("Résultats")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Votre Niveau d'Anxiété",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              category.isNotEmpty ? category : "Inconnu",
              style: TextStyle(fontSize: 22, color: Colors.green),
            ),
            Text(
              "Score d'anxiété : ${score.toStringAsFixed(2)}%", // ✅ Format du score
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Refaire le test"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(patientId: patientId),
                  ),
                );
              },
              child: Text("Voir l'historique"),
            ),
          ],
        ),
      ),
    );
  }
}
