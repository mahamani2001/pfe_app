import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../models/question_model.dart';
import '../services/api_service.dart'; // 📌 Importer le service API
import 'result_page.dart'; // 📌 Importer la page des résultats

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

  // 📌 Envoyer les résultats via ApiService
  void submitQuiz() async {
    List<String> answers = questions.map((q) => q.userAnswered).toList();
    String openAnswer = _textController.text;

    try {
      var result = await ApiService.sendQuizResults(answers, openAnswer);
      // Afficher les résultats
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
            category: result["category"],
            score: result["score"],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      print("❌ Erreur API : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EDE0),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color(0xFF17130D),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xFFA7C796),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Ionicons.help_outline),
            color: Colors.white,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestion + 1}/${questions.length}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                onPageChanged: (value) {
                  setState(() {
                    currentQuestion = value;
                  });
                },
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return ListView(
                    children: [
                      Text(
                        question.question,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25),
                      if (index == 14)
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
                            onChanged: (value) {
                              setState(() {
                                question.userAnswered = value;
                              });
                            },
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
                                selected: question.userAnswered == option,
                                activeColor: Color(0xFFFF7F50),
                                title: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    question.userAnswered = option;
                                  });
                                },
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
                onPressed: () {
                  if (currentQuestion < questions.length - 1) {
                    setState(() {
                      currentQuestion++;
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    });
                  } else {
                    submitQuiz();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA7C796),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  currentQuestion < questions.length - 1
                      ? "Suivant"
                      : "Envoyer",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
