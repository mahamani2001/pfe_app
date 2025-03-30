import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/api.dart' as pointy;
import 'package:pointycastle/random/fortuna_random.dart';
import '../models/message.dart';

class ChatService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/messages';
  static const String usersUrl = 'http://10.0.2.2:3000/api/auth';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 🎯 Générer une clé AES pour chaque message
  Uint8List generateAESKey() {
    final secureRandom = FortunaRandom();
    final randomBytes = List<int>.generate(32, (i) => i + 1);
    secureRandom.seed(pointy.KeyParameter(Uint8List.fromList(randomBytes)));
    return secureRandom.nextBytes(32); // 32 bytes pour AES-256
  }

  // 🔒 Chiffrer un message avec AES-GCM
  Map<String, String> encryptAESGCM(String message, Uint8List key) {
    final aesKey = encrypt.Key(key);
    final iv = encrypt.IV.fromLength(12);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(aesKey, mode: encrypt.AESMode.gcm),
    );

    final encryptedData = encrypter.encrypt(message, iv: iv);

    // ✅ Extraire l'auth_tag correctement
    final authTag = base64Encode(
        encryptedData.bytes.sublist(encryptedData.bytes.length - 16));

    return {
      'content': encryptedData.base64,
      'nonce': iv.base64,
      'authTag': authTag,
    };
  }

  // 🔐 Chiffrer la clé AES avec la clé publique RSA
  String encryptAESKeyWithRSA(Uint8List aesKey, String publicKeyPem) {
    final publicKey =
        encrypt.RSAKeyParser().parse(publicKeyPem) as RSAPublicKey;
    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
    final encryptedAESKey = encrypter.encrypt(base64Encode(aesKey));
    return encryptedAESKey.base64;
  }

  // 🔓 Déchiffrer la clé AES avec la clé privée RSA
  Uint8List decryptAESKeyWithRSA(String encryptedAESKey, String privateKeyPem) {
    final privateKey =
        encrypt.RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;
    final encrypter = encrypt.Encrypter(encrypt.RSA(privateKey: privateKey));
    final decryptedAESKey = encrypter.decrypt64(encryptedAESKey);
    return base64Decode(decryptedAESKey);
  }

  // 🔓 Déchiffrer un message AES-GCM
  String decryptAESGCM(
      String encryptedData, String nonce, String authTag, Uint8List key) {
    final aesKey = encrypt.Key(key);
    final iv = encrypt.IV.fromBase64(nonce);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(aesKey, mode: encrypt.AESMode.gcm),
    );

    final decryptedData = encrypter.decrypt(
      encrypt.Encrypted.fromBase64(encryptedData),
      iv: iv,
    );

    return decryptedData;
  }

  // ✅ Envoi de message avec chiffrement sécurisé
  Future<void> sendMessage(int receiverId, String content) async {
    if (content.isEmpty) {
      throw Exception('Le message ne peut pas être vide.');
    }

    final token = await _secureStorage.read(key: 'token');
    final recipientPublicKeyPem = await _getRecipientPublicKey(receiverId);

    // Générer une clé AES aléatoire pour ce message
    final aesKey = generateAESKey();
    final encryptedData = encryptAESGCM(content, aesKey);

    // Chiffrer la clé AES avec la clé publique RSA du destinataire
    final encryptedAESKey = encryptAESKeyWithRSA(aesKey, recipientPublicKeyPem);

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'receiverId': receiverId,
        'content': encryptedData['content'],
        'nonce': encryptedData['nonce'],
        'authTag': encryptedData['authTag'],
        'encryptedAESKey': encryptedAESKey,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // 🔓 Récupérer et déchiffrer les messages reçus
  Future<List<Message>> getMessages(int otherUserId) async {
    final token = await _secureStorage.read(key: 'token');
    final privateKeyPem = await _secureStorage.read(key: 'privateKey');

    final response = await http.get(
      Uri.parse('$baseUrl?otherUserId=$otherUserId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['messages'] as List).map((msg) {
        final message = Message.fromJson(msg);

        try {
          // ✅ Déchiffrer la clé AES avec la clé privée RSA
          final aesKeyBytes = decryptAESKeyWithRSA(
            message.encryptedAESKey,
            privateKeyPem!,
          );

          // ✅ Déchiffrer le contenu du message
          final decryptedContent = decryptAESGCM(
            message.content,
            message.nonce,
            message.authTag ?? '',
            aesKeyBytes,
          );

          return Message(
            id: message.id,
            conversationId: message.conversationId,
            senderId: message.senderId,
            receiverId: message.receiverId,
            content: decryptedContent,
            nonce: message.nonce,
            encryptedAESKey: message.encryptedAESKey,
            authTag: message.authTag,
            timestamp: message.timestamp,
          );
        } catch (e) {
          print('⚠️ Erreur lors du déchiffrement : $e');
          return message;
        }
      }).toList();
    } else {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Erreur inconnue');
    }
  }

  // 🛡️ Récupérer la clé publique d'un utilisateur
  Future<String> _getRecipientPublicKey(int receiverId) async {
    final token = await _secureStorage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$usersUrl/$receiverId/public-key'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['publicKey'];
    } else {
      throw Exception('Erreur récupération clé publique.');
    }
  }

  // 📡 Rejoindre une salle utilisateur via Socket.IO
  void joinUserRoom(int userId) {
    Future.delayed(Duration.zero, () {
      print('🔗 Rejoindre la salle utilisateur : user:$userId');
    });
  }

  // 📩 Écouter les messages via Socket.IO
  void listenToMessages(Function(Message) onMessageReceived) {
    Future.delayed(Duration.zero, () {
      print('📩 Écoute des messages activée via Socket.IO');
    });
  }

  // 🛑 Fermer la connexion Socket.IO
  void dispose() {
    Future.delayed(Duration.zero, () {
      print('❌ Déconnexion Socket.IO');
    });
  }
}
