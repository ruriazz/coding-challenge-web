import 'package:encrypt/encrypt.dart';

class Encryption {

  static String? encrypt({required String key, required String plainText}) {
    final Key _key = Key.fromUtf8(key);
    final IV iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    
    try {      
      final Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64; 
    } catch (e) {}
  }

  static String? decrypt({required String key, required String encrypted}) {
    final Key _key = Key.fromUtf8(key);
    final IV iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    
    try {
      final String decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
      return decrypted;
    } catch (e) {}
  }
}