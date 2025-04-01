import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../services/encryption_service.dart';

class ChatService {
  late IO.Socket _socket;

  void initChat(String userId) {
    _socket = IO.io('http://10.0.2.2:3000/api/auth', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      print('Connecté au serveur Socket.IO');
      _socket.emit('joinRoom', {'userId': userId});
    });
  }

  void sendMessage(String receiverId, String message) {
    final encryptedMessage = EncryptionService.encryptMessage(message);
    _socket.emit('sendMessage', {
      'receiverId': receiverId,
      'message': encryptedMessage,
    });
  }

  void listenForMessages(Function(String) onMessageReceived) {
    _socket.on('newMessage', (data) {
      final decryptedMessage =
          EncryptionService.decryptMessage(data['message']);
      onMessageReceived(decryptedMessage);
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
