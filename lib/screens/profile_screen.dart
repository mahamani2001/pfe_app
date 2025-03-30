/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    print('ProfileScreen - Utilisateur: ${user?.email}');

    if (user == null) {
      print('ProfileScreen - Utilisateur non connecté');
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    _dateOfBirthController.text = user.dateOfBirth ?? '';
    _genderController.text = user.gender ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, ${user.fullName} !',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${user.email}'),
            Text('Rôle: ${user.role}'),
            const SizedBox(height: 16),
            TextField(
              controller: _dateOfBirthController,
              decoration: const InputDecoration(
                labelText: 'Date de naissance (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(
                labelText: 'Genre',
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print('ProfileScreen - Bouton Mettre à jour le profil cliqué');
                try {
                  await authProvider.updateProfile(
                    _dateOfBirthController.text,
                    _genderController.text,
                  );
                  print('ProfileScreen - Profil mis à jour avec succès');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil mis à jour')),
                  );
                } catch (e) {
                  print('ProfileScreen - Erreur lors de la mise à jour: $e');
                  setState(() {
                    _errorMessage =
                        e.toString().replaceFirst('Exception: ', '');
                  });
                }
              },
              child: const Text('Mettre à jour le profil'),
            ),
          ],
        ),
      ),
    );
  }
}
 */
