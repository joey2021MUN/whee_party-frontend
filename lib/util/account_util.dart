import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/util/hash_util.dart';
import 'package:whee_party/util/network_util.dart';

typedef BoolCallBack = void Function(bool value);

class AccountUtil {
  static final _storage = LocalStorage("whee");

  static Future<String?> getStoredToken() async {
    await _storage.ready;
    return _storage.getItem("token");
  }

  static void setStoredToken(String token) {
    _storage.setItem("token", token);
  }

  static String _calculateSalt() {
    return "";
  }

  static Future<dynamic> signIn(String email, String password) async {
    password = HashUtil.hash(HashUtil.hash(password));
    return NetUtil.request("POST", "/signin",
        body: {"email": email, "password": password, "salt": _calculateSalt()},
        needAuthentication: false);
  }

  static void signOut(BuildContext context) {
    _storage.deleteItem("token");
    _storage.deleteItem("email");
    AccountModel.currentSessionToken = null;
    Provider.of<AccountModel>(context, listen: false).clearLoggingInInfo();
  }

  static Future<dynamic> greetings() async {
    return NetUtil.request("GET", "/greetings", needAuthentication: true);
  }

  static void tryAutoSignIn({
    required BuildContext context,
    required BoolCallBack? completion,
    required showToast,
    String? tempToken,
  }) async {
    tempToken ??= AccountModel.currentSessionToken;

    String? token = tempToken ?? await getStoredToken();
    if (token == null) {
      completion?.call(false);
      return;
    }

    greetings().then((result) {
      if (!result["success"]) {
        completion?.call(false);
        return;
      }

      if (showToast) {
        Fluttertoast.showToast(
          msg: result["message"],
          toastLength: Toast.LENGTH_SHORT,
        );
      }

      var state = Provider.of<AccountModel>(context, listen: false);
      state.updateLoggingInInfo(true, result["email"], result["full_name"]);
    }).catchError((_) {
      completion?.call(false);
      return;
    });
  }
}
