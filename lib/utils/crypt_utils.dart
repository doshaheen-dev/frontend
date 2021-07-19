import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as crypt;

class CryptUtils {
  static String encryption(String plainText) {
    if (plainText != null || plainText.isNotEmpty) {
      Uint8List ivData = Uint8List.fromList(
          [12, 34, 54, 78, 95, 90, 34, 32, 36, 24, 10, 40, 38, 42, 6, 3]);
      final key = crypt.Key.fromBase16('abf0129cefad8b2241fb41ef2540ddbf');
      final iv = crypt.IV(ivData);

      final encrypter = crypt.Encrypter(
          crypt.AES(key, mode: crypt.AESMode.cbc, padding: 'PKCS7'));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      print('Encrypted: ${encrypted.base64}');

      return encrypted.base64;
    } else {
      return '';
    }
  }

  static String decryption(String plainText) {
    if (plainText != null || plainText.isNotEmpty) {
      Uint8List ivData = Uint8List.fromList(
          [12, 34, 54, 78, 95, 90, 34, 32, 36, 24, 10, 40, 38, 42, 6, 3]);
      final key = crypt.Key.fromBase16('abf0129cefad8b2241fb41ef2540ddbf');
      final iv = crypt.IV(ivData);

      final encrypter = crypt.Encrypter(
          crypt.AES(key, mode: crypt.AESMode.cbc, padding: 'PKCS7'));

      final decrypted =
          encrypter.decrypt(crypt.Encrypted.fromBase64(plainText), iv: iv);
      print('Decrypted: $decrypted');

      return decrypted;
    } else {
      return '';
    }
  }
}
