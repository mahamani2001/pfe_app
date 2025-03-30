import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  String? _tempToken;

  User? get user => _user;
  String? get token => _token;

  final AuthService _authService = AuthService();

  Future<void> verifyOtp(String otp) async {
    final result = await _authService.verifyOtp(_tempToken!, otp);
    _user = result['user'];
    _token = result['token'];
    _tempToken = null;
    notifyListeners();
  }

  Future<void> updateProfile(String dateOfBirth, String gender) async {
    final updatedUser = await _authService.updateProfile(dateOfBirth, gender);
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> requestPasswordReset(String email) async {
    await _authService.requestPasswordReset(email);
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _authService.resetPassword(token, newPassword);
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _token = null;
    _tempToken = null;
    notifyListeners();
  }

  Future<void> register(String fullName, String email, String password) async {
    final result = await _authService.register(fullName, email, password);
    _user = result['user']; // Ensure this includes `id`
    _token = result['token'];
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final result = await _authService.login(email, password);
    _tempToken = result['tempToken'];
    notifyListeners();
  }
}
