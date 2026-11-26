import 'package:encrypt/encrypt.dart';

class CryptoService {
  static final key = Key.fromLength(32); // Use a secure 32-byte key
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));

  static String encryptData(String plainText) {
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  static String decryptData(String encryptedText) {
    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}