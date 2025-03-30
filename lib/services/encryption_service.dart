import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final _key = encrypt.Key.fromLength(32); // Clé AES de 256 bits
  static final _iv = encrypt.IV.fromLength(16); // IV de 128 bits

  // Chiffrer un message
  static Map<String, String> encryptMessage(String message) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(message, iv: _iv);
    return {
      'content': encrypted.base64,
      'nonce': _iv.base64,
      'authTag': '', // AES-GCM n'est pas utilisé ici, donc vide
      'encryptedAESKey': base64Encode(_key.bytes), // Simuler une clé chiffrée
    };
  }

  // Déchiffrer un message
  static String decryptMessage(String encryptedContent, String nonce) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final iv = encrypt.IV.fromBase64(nonce);
    final encrypted = encrypt.Encrypted.fromBase64(encryptedContent);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
