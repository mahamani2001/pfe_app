import 'package:flutter/material.dart';
import 'screens/question_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Question Page',
      home: QuestionPage(title: 'test'),
    );
  }
}
