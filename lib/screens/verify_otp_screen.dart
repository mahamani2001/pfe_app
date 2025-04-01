import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String tempToken;
  const VerifyOTPScreen({Key? key, required this.tempToken}) : super(key: key);

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;

  void _verifyOTP() async {
    setState(() => _isVerifying = true);

    try {
      final result =
          await _authService.verifyOTP(widget.tempToken, _otpController.text);
      if (result['token'] != null) {
        Navigator.pushNamed(context, '/home');
      } else {
        _showError('OTP incorrect ou expiré');
      }
    } catch (e) {
      _showError('Erreur lors de la vérification OTP');
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Entrez le code OTP envoyé à votre email'),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Code OTP'),
            ),
            const SizedBox(height: 20),
            _isVerifying
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOTP,
                    child: const Text('Vérifier'),
                  ),
          ],
        ),
      ),
    );
  }
}
