/*  import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/api.dart' as pointy;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'dart:math';
import 'package:asn1lib/asn1lib.dart';

class RSAService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, String>> generateRSAKeyPair() async {
    final keyGen = RSAKeyGenerator()
      ..init(
        pointy.ParametersWithRandom(
          RSAKeyGeneratorParameters(
            BigInt.from(65537),
            2048,
            64,
          ),
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

    return {'publicKey': publicKeyPem, 'privateKey': privateKeyPem};
  }

  pointy.SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seed = Uint8List(32);
    final random = Random.secure();
    for (int i = 0; i < 32; i++) {
      seed[i] = random.nextInt(256);
    }
    secureRandom.seed(pointy.KeyParameter(seed));
    return secureRandom;
  }

  String _rsaPublicKeyToPem(RSAPublicKey publicKey) {
    final algorithmSeq = ASN1Sequence();
    algorithmSeq
        .add(ASN1ObjectIdentifier.fromIdentifierString('1.2.840.113549.1.1.1'));
    algorithmSeq.add(ASN1Null());

    final keySeq = ASN1Sequence();
    keySeq.add(ASN1Integer(publicKey.modulus!));
    keySeq.add(ASN1Integer(publicKey.exponent!));
    final keyBitString = ASN1BitString(keySeq.encodedBytes);

    final topSeq = ASN1Sequence();
    topSeq.add(algorithmSeq);
    topSeq.add(keyBitString);

    final der = topSeq.encodedBytes;
    final base64 = base64Encode(der);
    final pem = '''
-----BEGIN PUBLIC KEY-----
${base64.splitMapJoin(RegExp(r'.{64}'), onMatch: (m) => '${m.group(0)}\n', onNonMatch: (n) => n)}
-----END PUBLIC KEY-----
''';
    return pem.trim();
  }

  String _rsaPrivateKeyToPem(RSAPrivateKey privateKey) {
    final version = ASN1Integer(BigInt.zero);
    final modulus = ASN1Integer(privateKey.modulus!);
    final publicExponent = ASN1Integer(privateKey.exponent!);
    final privateExponent = ASN1Integer(privateKey.privateExponent!);
    final p = ASN1Integer(privateKey.p!);
    final q = ASN1Integer(privateKey.q!);
    final dp =
        ASN1Integer(privateKey.privateExponent! % (privateKey.p! - BigInt.one));
    final dq =
        ASN1Integer(privateKey.privateExponent! % (privateKey.q! - BigInt.one));
    final inverseQ = ASN1Integer(privateKey.q!.modInverse(privateKey.p!));

    final seq = ASN1Sequence();
    seq.add(version);
    seq.add(modulus);
    seq.add(publicExponent);
    seq.add(privateExponent);
    seq.add(p);
    seq.add(q);
    seq.add(dp);
    seq.add(dq);
    seq.add(inverseQ);

    final der = seq.encodedBytes;
    final base64 = base64Encode(der);
    final pem = '''
-----BEGIN RSA PRIVATE KEY-----
${base64.splitMapJoin(RegExp(r'.{64}'), onMatch: (m) => '${m.group(0)}\n', onNonMatch: (n) => n)}
-----END RSA PRIVATE KEY-----
''';
    return pem.trim();
  }

  Future<String?> getPrivateKey() async {
    return await _secureStorage.read(key: 'privateKey');
  }

  Future<String?> getPublicKey() async {
    return await _secureStorage.read(key: 'publicKey');
  }

  Future<void> generateAndSaveKeysIfNeeded() async {
    final privateKey = await _secureStorage.read(key: 'privateKey');
    final publicKey = await _secureStorage.read(key: 'publicKey');

    if (privateKey == null || publicKey == null) {
      print('🔐 Clés RSA manquantes. Génération en cours...');
      await generateRSAKeyPair();
    } else {
      print('✅ Clés RSA déjà présentes.');
    }
  }
}
 
 */
