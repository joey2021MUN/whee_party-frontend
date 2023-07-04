import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:whee_party/util/ui_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _errorTextEmail = "";
  String _errorTextPassword = "";
  bool _shouldShowErrorTextEmail = false;
  bool _shouldShowErrorTextPassword = false;
  bool _shouldRememberMe = true;
  bool _isLoading = false;
  var emailController = TextEditingController(text: "123@gmail.com");
  var passwordController = TextEditingController(text: "123");

  void _onLoginClicked() {
    var email = emailController.value.text;
    var password = passwordController.value.text;

    if (email.isEmpty /* || password.isEmpty */) {
      if (email.isEmpty) {
        setState(() {
          _errorTextEmail = "Please enter a valid email address.";
          _shouldShowErrorTextEmail = true;
        });
      }
      if (password.isEmpty) {
        setState(() {
          _errorTextPassword = "Please enter a valid password.";
          _shouldShowErrorTextPassword = true;
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

      AccountUtil.setStoredToken(token);
      AccountUtil.tryAutoSignIn(context: context, showToast: true, completion: null);
      Navigator.pop(context);
    }).catchError((_) {

    });
  }

  void _onCreateAnAccountClicked() {

  }

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
    var errorTextPassword = Text(
      _errorTextPassword,
      style: const TextStyle(color: Colors.redAccent),
    );

    return Material(
      child: Container(
        margin: const EdgeInsets.fromLTRB(48, 0, 48, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            const Spacer(flex: 1),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: const Text(
                "Log In",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
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
                      fontSize: 20,
                    ),
                    controller: emailController,
                  ),
                  ...(_shouldShowErrorTextEmail ? [errorTextEmail] : []),
                  /*
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  CupertinoTextField(
                    obscureText: true,
                    placeholder: "Enter your password",
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    controller: passwordController,
                  ),
                  ...(_shouldShowErrorTextPassword ? [errorTextPassword] : [])
                   */
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
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: FilledButton(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
