import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _token;
  bool _isAuthenticated = false;

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  // Inscription
  Future<void> register(
      String fullName, String email, String password, String publicKey) async {
    try {
      final response =
          await _authService.register(fullName, email, password, publicKey);
      _token = response['token'];
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;
      notifyListeners();
    } catch (error) {
      throw Exception('Erreur lors de l’inscription : $error');
    }
  }

  // Connexion
  Future<void> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      if (response['twoFactorRequired'] == true) {
        _token = response['tempToken'];
      } else {
        _token = response['token'];
        _user = User.fromJson(response['user']);
        _isAuthenticated = true;
      }
      notifyListeners();
    } catch (error) {
      throw Exception('Erreur lors de la connexion : $error');
    }
  }

  // Vérification OTP
  Future<void> verifyOTP(String tempToken, String otp) async {
    try {
      final response = await _authService.verifyOTP(tempToken, otp);
      _token = response['token'];
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;
      notifyListeners();
    } catch (error) {
      throw Exception('Erreur lors de la vérification OTP : $error');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      await _authService.logout(_token!);
      _user = null;
      _token = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (error) {
      throw Exception('Erreur lors de la déconnexion : $error');
    }
  }
}
