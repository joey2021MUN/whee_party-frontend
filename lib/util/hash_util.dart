import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashUtil {
  static String hash(String s) {
    List<int> bytes = utf8.encode(s);
    return sha256.convert(bytes).toString();
  }
}
