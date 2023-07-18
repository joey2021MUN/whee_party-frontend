import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:whee_party/util/ui_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _errorTextEmail = "";
  bool _shouldShowErrorTextEmail = false;
  bool _shouldRememberMe = true;
  bool _isLoading = false;
  var emailController = TextEditingController(text: "123@gmail.com");
  var passwordController = TextEditingController(text: "123");

  void _onLoginClicked() {
    var email = emailController.value.text;
    var password = passwordController.value.text;

    if (email.isEmpty) {
      if (email.isEmpty) {
        setState(() {
          _errorTextEmail = "Please enter a valid email address.";
          _shouldShowErrorTextEmail = true;
        });
      }
      return;
    }

    UIUtil.showLoadingDialog(context, "Logging in...");
    setState(() {
      _isLoading = true;
    });

    AccountUtil.signIn(email, password).then((result) {
      if (!result["success"]) {
        UIUtil.updateLoadingDialog(context, result["message"]);
        Future.delayed(const Duration(seconds: 2), () {
          UIUtil.closeLoadingDialog(context);
        });
        setState(() {
          _isLoading = false;
        });
        return;
      }

      UIUtil.closeLoadingDialog(context);
      setState(() {
        _isLoading = false;
      });
      var token = result["token"];

      if (_shouldRememberMe) {
        AccountUtil.setStoredToken(token);
      }

      AccountModel.currentSessionToken = token;
      AccountUtil.tryAutoSignIn(
        context: context,
        tempToken: token,
        showToast: true,
        completion: null,
      );
      Navigator.pop(context);
    }).catchError((_) {});
  }

  void _onContinueAsGuestClicked() {
    Navigator.pop(context);
  }

  // Todo
  void _onCreateAnAccountClicked() {}

  void _onShouldRememberMeCheckBoxChanged(bool? newValue) {
    setState(() {
      _shouldRememberMe = newValue ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var errorTextEmail = Text(
      _errorTextEmail,
      style: const TextStyle(color: Colors.redAccent),
    );

    return Material(
      child: Container(
        margin: const EdgeInsets.fromLTRB(48, 0, 48, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Spacer(flex: 1),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: const Text(
                "Welcome to\nWhee Indoor Playground",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  CupertinoTextField(
                    placeholder: "Enter your email",
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    controller: emailController,
                  ),
                  ...(_shouldShowErrorTextEmail ? [errorTextEmail] : []),
                ],
              ),
            ),
            FilledButton(
              onPressed: _isLoading ? null : _onLoginClicked,
              style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(Colors.lightBlue),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _shouldRememberMe,
                  onChanged: _onShouldRememberMeCheckBoxChanged,
                ),
                const Text("Remember Me", style: TextStyle(fontSize: 16))
              ],
            ),
            const Spacer(flex: 1),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Column(
                      children: [
                        FilledButton(
                          onPressed: _onCreateAnAccountClicked,
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.green),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: _onContinueAsGuestClicked,
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                            child: const Text(
                              "Continue as Guest",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
