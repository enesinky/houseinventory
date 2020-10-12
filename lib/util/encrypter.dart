import 'package:crypto/crypto.dart';
import 'dart:convert';
class Encrypter {

 // for the utf8.encode method
  String SHA256(String input) {
    var bytes = utf8.encode(input); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

}