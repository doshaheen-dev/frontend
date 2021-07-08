import 'package:encrypt/encrypt.dart' as crypt;

class CryptUtils {
  crypt.Key key; // = Key.fromLength(32);
  crypt.IV iv; // = IV.fromLength(16);
  crypt.Encrypter encrypter;

  CryptUtils(crypt.Key key, crypt.IV iv) {
    this.key = key;
    this.iv = iv;
    this.encrypter = crypt.Encrypter(crypt.AES(key));
  }

  String encrypt(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // print(encrypted.bytes);
    // print(encrypted.base16);
    // print(encrypted.base64);
    return encrypted.base64;
  }

  String decrypt(crypt.Encrypted encrypted) {
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    // print("Decr: $decrypted");
    return decrypted;
  }
}
