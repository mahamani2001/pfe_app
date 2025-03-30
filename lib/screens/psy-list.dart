import 'package:flutter/material.dart';
import 'package:pfe_app/services/auth_service.dart';
import '../models/user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final AuthService _userService = AuthService();
  List<User> _users = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Récupère les utilisateurs/psychiatres à l'initialisation
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      print('❌ Erreur lors de la récupération des psychiatres : $error');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Impossible de récupérer la liste des psychiatres.';
      });
    }
  }

  // 🚀 Ouvre la conversation avec le bon psychiatre
  void _openChat(int receiverId) {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: receiverId, // Passe l'ID du psychiatre au ChatScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Psychiatres')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchUsers,
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(
                          user.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user.email),
                        trailing: const Icon(Icons.chat, color: Colors.green),
                        onTap: () => _openChat(user.id), // Ouvrir la conversation
                      );
                    },
                  ),
                ),
    );
  }
}
