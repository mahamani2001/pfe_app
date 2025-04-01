import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/chat_provider.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './screens/verify_otp_screen.dart';
import './screens/chat_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Sécurisé',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/verify-otp': (context) => const VerifyOTPScreen(tempToken: ''),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => ChatScreen(receiverId: ''),
      },
    );
  }
}
