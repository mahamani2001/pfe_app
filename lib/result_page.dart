import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String category;
  final double score;

  ResultPage({required this.category, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Résultats du Test")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Votre Niveau d'Anxiété",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              category,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: category == "Very High"
                    ? Colors.red
                    : category == "High"
                        ? Colors.orange
                        : category == "Moderate"
                            ? Colors.yellow[700]
                            : Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Score d'anxiété : ${score.toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Refaire le test"),
            ),
          ],
        ),
      ),
    );
  }
}
