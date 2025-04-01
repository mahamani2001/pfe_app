import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  // Chiffrer un message
  static String encryptMessage(String message) {
    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted.base64;
  }

  // Déchiffrer un message
  static String decryptMessage(String encryptedMessage) {
    final decrypted = encrypter.decrypt64(encryptedMessage, iv: iv);
    return decrypted;
  }
}
