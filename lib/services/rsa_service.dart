import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:asn1lib/asn1lib.dart';

class RSAService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, String>> generateRSAKeyPair() async {
    final keyGen = RSAKeyGenerator()
      ..init(
        crypto.ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
          _getSecureRandom(),
        ),
      );

    final pair = keyGen.generateKeyPair();
    final publicKey = pair.publicKey as RSAPublicKey;
    final privateKey = pair.privateKey as RSAPrivateKey;

    final publicKeyPem = _rsaPublicKeyToPem(publicKey);
    final privateKeyPem = _rsaPrivateKeyToPem(privateKey);

    await _secureStorage.write(key: 'publicKey', value: publicKeyPem);
    await _secureStorage.write(key: 'privateKey', value: privateKeyPem);

    print('🔑 Clé publique générée : $publicKeyPem');
    print('🔑 Clé privée générée : $privateKeyPem');

    return {'publicKey': publicKeyPem, 'privateKey': privateKeyPem};
  }

  crypto.SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seed = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    secureRandom.seed(crypto.KeyParameter(seed));
    return secureRandom;
  }

  String _rsaPublicKeyToPem(RSAPublicKey publicKey) {
    final sequence = ASN1Sequence();
    sequence.add(ASN1Integer(publicKey.modulus!));
    sequence.add(ASN1Integer(publicKey.exponent!));
    final der = sequence.encodedBytes;
    final base64 = base64Encode(der);
    return '''
-----BEGIN PUBLIC KEY-----
${_formatBase64(base64)}
-----END PUBLIC KEY-----
''';
  }

  String _rsaPrivateKeyToPem(RSAPrivateKey privateKey) {
    final p = privateKey.p!;
    final q = privateKey.q!;
    final d = privateKey.privateExponent!;
    final e = privateKey.publicExponent!;

    final dP = d % (p - BigInt.one);
    final dQ = d % (q - BigInt.one);
    final qInv = q.modInverse(p);

    final privateKeySeq = ASN1Sequence();
    privateKeySeq.add(ASN1Integer(BigInt.zero)); // Version (0)
    privateKeySeq.add(ASN1Integer(privateKey.modulus!)); // n
    privateKeySeq.add(ASN1Integer(e)); // e
    privateKeySeq.add(ASN1Integer(d)); // d
    privateKeySeq.add(ASN1Integer(p)); // p
    privateKeySeq.add(ASN1Integer(q)); // q
    privateKeySeq.add(ASN1Integer(dP)); // d mod (p-1)
    privateKeySeq.add(ASN1Integer(dQ)); // d mod (q-1)
    privateKeySeq.add(ASN1Integer(qInv)); // q^-1 mod p

    final der = privateKeySeq.encodedBytes;
    final base64 = base64Encode(der);
    return '''
-----BEGIN RSA PRIVATE KEY-----
${_formatBase64(base64)}
-----END RSA PRIVATE KEY-----
''';
  }

  String _formatBase64(String base64String) {
    final buffer = StringBuffer();
    for (var i = 0; i < base64String.length; i += 64) {
      final end = (i + 64 < base64String.length) ? i + 64 : base64String.length;
      buffer.writeln(base64String.substring(i, end));
    }
    return buffer.toString().trim();
  }

  Future<String?> getPrivateKey() async {
    return await _secureStorage.read(key: 'privateKey');
  }

  Future<String?> getPublicKey() async {
    return await _secureStorage.read(key: 'publicKey');
  }

  Future<void> deleteKeys() async {
    await _secureStorage.delete(key: 'publicKey');
    await _secureStorage.delete(key: 'privateKey');
    print('🔐 Clés supprimées avec succès.');
  }
}
