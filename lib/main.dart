import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/verify_otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reset_password_request_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/psy-list.dart'; // ➕ Import de UserListScreen
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';

void main() {
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login', // ⚡️ Démarre par la page de login
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/verify-otp': (context) => const VerifyOtpScreen(),
        '/home': (context) => const HomeScreen(),

        '/users': (context) =>
            const UserListScreen(), // ➕ Ajoute la route des utilisateurs
        '/chat': (context) => ChatScreen(
              receiverId: ModalRoute.of(context)!.settings.arguments as int,
            ),
      },
    );
  }
}
