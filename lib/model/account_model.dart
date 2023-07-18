import 'package:flutter/foundation.dart';
import 'package:whee_party/model/user.dart';

class AccountModel extends ChangeNotifier {
  bool _isSignedIn = false;
  User? _currentUser;

  bool get isSignedIn => _isSignedIn;
  User? get currentUser => _currentUser;

  static String? currentSessionToken;

  void updateLoggingInInfo(
    bool isSignedIn,
    User? currentUser,
  ) {
    _isSignedIn = isSignedIn;
    _currentUser = currentUser;
    notifyListeners();
  }

  void clearLoggingInInfo() {
    _isSignedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
