import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<Message> _messages = [];
  bool _isConnected = false;
  String? _userId; // Stocker l'ID de l'utilisateur connecté

  // Getter des messages
  List<Message> get messages => _messages;

  // Initialiser le chat avec l'ID utilisateur
  void initChat(String userId) {
    if (!_isConnected) {
      _userId = userId;
      _chatService.initChat(userId);
      _listenForMessages();
      _isConnected = true;
    }
  }

  // Envoyer un message
  void sendMessage(int receiverId, String content) {
    if (_userId == null) {
      throw Exception('ID utilisateur non défini');
    }

    _chatService.sendMessage(receiverId.toString(), content);

    final message = Message(
      id: _messages.length + 1,
      senderId: int.parse(_userId!),
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now().toIso8601String(),
    );
    _messages.add(message);
    notifyListeners();
  }

  // Écouter les messages entrants
  void _listenForMessages() {
    _chatService.listenForMessages((String content) {
      final message = Message(
        id: _messages.length + 1,
        senderId: 0, // À mettre à jour si besoin
        receiverId: 0, // À mettre à jour si besoin
        content: content,
        timestamp: DateTime.now().toIso8601String(),
      );
      _messages.add(message);
      notifyListeners();
    });
  }

  // Déconnexion
  void disconnect() {
    _chatService.disconnect();
    _isConnected = false;
  }

  // Effacer les messages après la déconnexion
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
