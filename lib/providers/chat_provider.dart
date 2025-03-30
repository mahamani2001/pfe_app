import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<Message> _messages = [];
  bool _isLoading = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  // ✅ Charger les messages
  Future<void> loadMessages(int receiverId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _messages = await _chatService.getMessages(receiverId);
      print('✅ Messages chargés : ${_messages.length}');
    } catch (e) {
      print('⚠️ Erreur chargement messages: $e');
      _messages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Envoyer un message
  Future<void> sendMessage(int receiverId, String content) async {
    try {
      await _chatService.sendMessage(receiverId, content);
      loadMessages(receiverId); // Recharge les messages après l'envoi
    } catch (e) {
      print('⚠️ Erreur envoi message: $e');
    }
  }

  // ✅ Écouter les nouveaux messages via Socket.IO
  void listenToMessages(int userId) {
    _chatService.joinUserRoom(userId);
    _chatService.listenToMessages((message) {
      if (!_messages.any((msg) => msg.id == message.id)) {
        _messages.add(message);
        notifyListeners();
      }
    });
  }

  // ✅ Vider les messages
  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  // ✅ Fermer la connexion Socket.IO
  void disposeService() {
    _chatService.dispose();
  }
}
