import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:whee_party/util/dialog_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _errorTextEmail = "";
  String _errorTextPhoneNumber = "";
  String _errorTextFullName = "";
  String _errorTextPassword = "";

  bool _shouldShowErrorTextEmail = false;
  bool _shouldShowErrorPhoneNumber = false;
  bool _shouldShowErrorFullName = false;
  bool _shouldShowErrorPassword = false;

  bool _isLoading = false;
  var emailController = TextEditingController(text: "123@gmail.com");
  var passwordController = TextEditingController(text: "123");
  var fullNameController = TextEditingController(text: "");
  var phoneNumberController = TextEditingController(text: "");

  void _onCreateAccountClicked() {
    var email = emailController.value.text;
    var password = passwordController.value.text;
    var fullName = fullNameController.value.text;
    var phoneNumber = phoneNumberController.value.text;

    if (email.isEmpty) {
      setState(() {
        _errorTextEmail = "Please enter a valid email address.";
        _shouldShowErrorTextEmail = true;
      });
      return;
    }

    /*
    if (password.isEmpty) {
      setState(() {
        _errorTextPassword = "Please enter a valid password.";
        _shouldShowErrorPassword = true;
      });
      return;
    }

    if (fullName.isEmpty) {
      setState(() {
        _errorTextFullName = "Please enter your full name.";
        _shouldShowErrorFullName = true;
      });
      return;
    }

    if (phoneNumber.isEmpty) {
      setState(() {
        _errorTextPhoneNumber = "Please enter your phone number.";
        _shouldShowErrorPhoneNumber = true;
      });
      return;
    }
    */

    DialogUtil.showLoadingDialog(context, "Signing up...");
    setState(() {
      _isLoading = true;
    });

    AccountUtil.signUp(
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      password: password,
    ).then((result) {
      if (!result["success"]) {
        DialogUtil.updateLoadingDialog(context, result["message"]);
        Future.delayed(const Duration(seconds: 2), () {
          DialogUtil.closeLoadingDialog(context);
        });
        setState(() {
          _isLoading = false;
        });
        return;
      }

      DialogUtil.updateLoadingDialog(context, result["message"]);
      Future.delayed(const Duration(seconds: 2), () {
        DialogUtil.closeLoadingDialog(context);

        var token = result["token"];

        AccountUtil.setStoredToken(token);
        AccountModel.currentSessionToken = token;
        AccountUtil.tryAutoSignIn(
          context: context,
          tempToken: token,
          showToast: true,
          completion: null,
        );
        Navigator.pop(context);

        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  Widget _makeFormItem({
    TextEditingController? controller,
    required String title,
    required String placeholder,
    required bool shouldShowError,
    required String errorText,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          CupertinoTextField(
            placeholder: placeholder,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            style: const TextStyle(
              fontSize: 16,
            ),
            controller: controller,
          ),
          ...(shouldShowError
              ? [
                  Text(
                    errorText,
                    style: const TextStyle(color: Colors.redAccent),
                  )
                ]
              : []),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.fromLTRB(48, 0, 48, 0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
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
              _makeFormItem(
                title: "Email",
                placeholder: "Enter your email",
                shouldShowError: _shouldShowErrorTextEmail,
                errorText: _errorTextEmail,
                controller: emailController,
              ),
              /*
              _makeFormItem(
                title: "Full Name",
                placeholder: "Enter your name",
                shouldShowError: _shouldShowErrorFullName,
                errorText: _errorTextFullName,
                controller: fullNameController,
              ),
              _makeFormItem(
                title: "Password",
                placeholder: "",
                shouldShowError: _shouldShowErrorTextEmail,
                errorText: _errorTextPassword,
                controller: passwordController,
              ),
              _makeFormItem(
                title: "Phone Number",
                placeholder: "Enter your phone number",
                shouldShowError: _shouldShowErrorTextEmail,
                errorText: _errorTextPhoneNumber,
                controller: phoneNumberController,
              ),
              */
              Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: FilledButton(
                  onPressed: _isLoading ? null : _onCreateAccountClicked,
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.lightBlue),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
