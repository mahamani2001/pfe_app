import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/rsa_service.dart'; // Utilisation de RSAService

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/auth';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final RSAService _rsaService =
      RSAService(); // Utilise RSAService pour les clés

  // ✅ Enregistrement de l'utilisateur avec génération des clés RSA
  Future<Map<String, dynamic>> register(
      String fullName, String email, String password) async {
    // Générer une nouvelle paire de clés RSA
    final keyPair = await _rsaService.generateRSAKeyPair();
    final publicKey = keyPair['publicKey'];
    final privateKey = keyPair['privateKey'];

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
        'public_key': publicKey,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return {'user': User.fromJson(data['user']), 'token': data['token']};
    } else {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // ✅ Connexion de l'utilisateur
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'tempToken': data['tempToken']};
    } else {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // ✅ Vérification OTP après connexion
  Future<Map<String, dynamic>> verifyOtp(String tempToken, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tempToken': tempToken, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return {'user': User.fromJson(data['user']), 'token': data['token']};
    } else {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // ✅ Mettre à jour le profil de l'utilisateur
  Future<User> updateProfile(String dateOfBirth, String gender) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/update-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date_of_birth': dateOfBirth,
        'gender': gender,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // ✅ Demande de réinitialisation de mot de passe
  Future<void> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/request-password-reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // ✅ Réinitialiser le mot de passe
  Future<void> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // ✅ Déconnexion de l'utilisateur
  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'privateKey'); // Supprime la clé privée
  }

  // ✅ Sauvegarder le token JWT
  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  // ✅ Récupérer le token JWT
  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<List<User>> getUsers() async {
    final token = await _secureStorage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['users'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des utilisateurs.');
    }
  }
}
