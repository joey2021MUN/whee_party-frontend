import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:whee_party/util/network_util.dart';
import 'package:whee_party/util/ui_util.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({Key? key}) : super(key: key);

  @override
  EditProfileWidgetState createState() => EditProfileWidgetState();
}

class EditProfileWidgetState extends State<EditProfileWidget> {
  Widget _buildEditRow(_UserProperty property) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: property.controller,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // First row: edit full name
    // Second row: edit email
    // Third row: edit phone number
    // Fourth row: save button
    var state = Provider.of<AccountModel>(context, listen: false);
    var user = state.currentUser!;

    var fullNameProperty = _UserProperty("Full Name", user.fullName);
    var emailProperty = _UserProperty("Email", user.email);
    var phoneNumberProperty = _UserProperty("Phone Number", user.phoneNumber);

    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Material(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditRow(fullNameProperty),
              const SizedBox(height: 15),
              _buildEditRow(emailProperty),
              const SizedBox(height: 15),
              _buildEditRow(phoneNumberProperty),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            user.setFullName(fullNameProperty.controller.text);
            user.setEmail(emailProperty.controller.text);
            user.setPhoneNumber(phoneNumberProperty.controller.text);

            NetUtil.updateSelfUser(user).then((_) {
              state.updateLoggingInInfo(true, user);
              Navigator.of(context).pop();
            }).catchError((error) {
              UIUtil.alertDialog(context, error);
            });
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _UserProperty {
  final String title;
  late TextEditingController controller;

  _UserProperty(this.title, String initialValue) {
    controller = TextEditingController(text: initialValue);
  }
}
