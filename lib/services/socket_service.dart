import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  // ✅ Connecter à Socket.IO
  void connect(int userId) {
    socket = IO.io(
      'http://10.0.2.2:3000', // Assure-toi que l'URL est correcte
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'userId': userId.toString()}).build(),
    );

    socket.onConnect((_) {
      print('✅ Connecté au serveur Socket.IO');
    });

    socket.onDisconnect((_) {
      print('❌ Déconnecté de Socket.IO');
    });
  }

  // ✅ Envoyer un message via Socket.IO
  void sendMessage(Map<String, dynamic> message) {
    socket.emit('sendMessage', message);
  }

  // ✅ Écouter les nouveaux messages
  void listenForMessages(Function(dynamic) onMessageReceived) {
    socket.on('newMessage', (data) {
      onMessageReceived(data);
    });
  }

  // ✅ Déconnexion de Socket.IO
  void disconnect() {
    socket.disconnect();
  }
}
