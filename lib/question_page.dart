import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import './models/question_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EDE0), // Fond beige doux
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color(0xFF17130D), // Texte noir/brun foncé
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 4, // Ombre plus marquée
        backgroundColor: Color(0xFFA7C796), // Couleur principale (Coral)
        shadowColor: Colors.black26,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Icônes blanches pour meilleur contraste
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Ionicons.help_outline),
            splashRadius: 24,
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                              hintText: "Votre hiiisf ici...",
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
                        ...List.generate(4, (optionIndex) {
                          final option = question.options[optionIndex];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: RadioListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                value: option,
                                groupValue: question.userAnswered,
                                selected: question.userAnswered == option,
                                activeColor: (Color(0xFFFF7F50)),
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
                            ),
                          );
                        })
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
                    // Action à exécuter à la fin du quiz
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
