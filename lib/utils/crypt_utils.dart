import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as crypt;

class CryptUtils {
  String encryption(String plainText) {
    Uint8List ivData = Uint8List.fromList(
        [12, 34, 54, 78, 95, 90, 34, 32, 36, 24, 10, 40, 38, 42, 6, 3]);
    final key = crypt.Key.fromBase16('abf0129cefad8b2241fb41ef2540ddbf');
    final iv = crypt.IV(ivData);

    final encrypter = crypt.Encrypter(
        crypt.AES(key, mode: crypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print('Encrypted: ${encrypted.base64}');

    return encrypted.base64;
  }

  String decryption(String plainText) {
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
  }

  // crypt.Key key;
  // crypt.IV iv;
  // crypt.Encrypter encrypter;

  // CryptUtils(String key, Uint8List iv) {
  //   this.key = crypt.Key.fromBase64(key);
  //   this.iv = crypt.IV(iv);
  //   this.encrypter =
  //       crypt.Encrypter(crypt.AES(this.key, mode: crypt.AESMode.cbc));
  // }

  // String encrypt(String plainText) {
  //   final encrypted = encrypter.encrypt(plainText, iv: iv);
  //   // print(encrypted.bytes);
  //   // print(encrypted.base16);
  //   print(encrypted.base64);
  //   return encrypted.base64;
  // }

  // String decrypt(String encrypted) {
  //   final encryptedText = crypt.Encrypted.fromBase64(encrypted);
  //   final decrypted = encrypter.decrypt(encryptedText, iv: iv);
  //   print("Decr: $decrypted");
  //   return decrypted;
  // }
}
