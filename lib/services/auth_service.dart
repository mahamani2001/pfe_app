import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/api/auth';

  // Gérer la réponse JSON et les erreurs
  String handleResponse(http.Response response) {
    try {
      final decodedResponse = jsonDecode(response.body);
      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey('message')) {
        return decodedResponse['message'];
      } else {
        return 'Réponse inattendue du serveur';
      }
    } catch (e) {
      return 'Erreur lors du traitement de la réponse : ${e.toString()}';
    }
  }

  // Inscription
  Future<Map<String, dynamic>> register(
      String fullName, String email, String password, String publicKey) async {
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
      return jsonDecode(response.body);
    } else {
      throw Exception(handleResponse(response));
    }
  }

  // Connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(handleResponse(response));
    }
  }

  // Vérification OTP
  Future<Map<String, dynamic>> verifyOTP(String tempToken, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tempToken': tempToken, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(handleResponse(response));
    }
  }

  // Déconnexion
  Future<void> logout(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode != 200) {
      throw Exception('Échec de la déconnexion');
    }
  }
}
