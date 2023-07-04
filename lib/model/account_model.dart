import 'package:flutter/foundation.dart';

class AccountModel extends ChangeNotifier {
  bool _isSignedIn = false;
  String _loggingInEmail = "(N/A)";
  String _loggingFullName = "Guest";

  bool get isSignedIn => _isSignedIn;
  String get loggingInEmail => _loggingInEmail;
  String get loggingFullName => _loggingFullName;

  void updateLoggingInInfo(bool isSignedIn, String email, String fullname) {
    _isSignedIn = isSignedIn;
    _loggingInEmail = email;
    _loggingFullName = fullname;
    notifyListeners();
  }

  void clearLoggingInInfo() {
    _isSignedIn = false;
    _loggingInEmail = "(N/A)";
    _loggingFullName = "Guest";
  }
}
