import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId; // ✅ ID du psychiatre sélectionné
  const ChatScreen({Key? key, required this.receiverId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // ✅ Initialiser le chat avec l'ID de l'utilisateur connecté
    if (authProvider.user != null) {
      chatProvider.initChat(authProvider.user!.id.toString());
    }
  }

  // ✅ Envoyer un message au psychiatre
  void _sendMessage(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    if (_messageController.text.isNotEmpty) {
      chatProvider.sendMessage(
          int.parse(widget.receiverId), _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat sécurisé')),
      body: Column(
        children: [
          // ✅ Afficher les messages envoyés et reçus
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                final isMe = message.senderId.toString() ==
                    Provider.of<AuthProvider>(context, listen: false)
                        .user
                        ?.id
                        .toString();
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          // ✅ Zone de saisie pour envoyer un message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
