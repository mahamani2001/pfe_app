import 'package:flutter/material.dart';

import '../models/question_model.dart';
import '../services/api_service.dart';
import 'result_page.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currentQuestion = 0;
  final PageController _pageController = PageController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // 📌 Envoyer les réponses via ApiService
  void submitQuiz() async {
    List<String> answers = questions.map((q) => q.userAnswered).toList();
    String patientId = "2"; // Assume patient ID is known

    try {
      var result = await ApiService.sendQuizResults(answers, patientId);

      if (result == null) {
        print("❌ API returned null");
        return;
      }

      print("📌 API Response Processed: $result");

      // ✅ Navigate to Result Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            patientId: patientId,
            category: result["niveau_anxiete"],
            score: result["score"], // ✅ Convert null to 0.0
          ),
        ),
      );
    } catch (e) {
      print(" Error in API call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EDE0),
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFA7C796),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Question ${currentQuestion + 1}/${questions.length}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 25),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                onPageChanged: (value) =>
                    setState(() => currentQuestion = value),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return ListView(
                    children: [
                      Text(question.question,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      SizedBox(height: 25),
                      if (index ==
                          14) // 🔹 Question ouverte (dernière question)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Votre réponse ici...",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )
                      else
                        Column(
                          children: List.generate(question.options.length,
                              (optionIndex) {
                            final option = question.options[optionIndex];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: RadioListTile(
                                value: option,
                                groupValue: question.userAnswered,
                                activeColor: Color(0xFFFF7F50),
                                title: Text(option,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                onChanged: (value) => setState(
                                    () => question.userAnswered = option),
                              ),
                            );
                          }),
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => currentQuestion < questions.length - 1
                    ? _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut)
                    : submitQuiz(),
                child: Text(currentQuestion < questions.length - 1
                    ? "Suivant"
                    : "Envoyer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
