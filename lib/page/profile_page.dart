import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/page/login_page.dart';
import 'package:whee_party/widget/edit_profile_widget.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:whee_party/widget/my_orders_dialog_content.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AccountModel state;

  void _onLogoutButtonClicked() {
    if (state.isSignedIn) {
      AccountUtil.signOut(context);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  void onEditProfile() {
    showDialog(context: context, builder: (_) => const EditProfileWidget());
  }

  void onChangePassword() {}

  void onFillWaiver() {}

  void onSettings() {}

  void onMyOrders() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("My Parties"),
        content: MyOrdersDialogContent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AccountModel>(context, listen: true);
    late Widget widget;

    if (state.isSignedIn) {
      var user = state.currentUser!;
      var options = <_ProfileOption>[
        _ProfileOption("My Parties", onMyOrders),
        _ProfileOption("Edit Profile", onEditProfile),
        _ProfileOption("Change Password", onChangePassword),
        _ProfileOption("Fill Waiver", onFillWaiver),
        _ProfileOption("Settings", onSettings),
        _ProfileOption("Logout", _onLogoutButtonClicked),
      ];

      widget = Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              // Rounded corners and bright background, no shadow
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(user.email, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(user.phoneNumber,
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const Spacer(),
                  // const Text("Avatar"),
                ],
              ),
            ),
            const Divider(thickness: 0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (_, int index) {
                return ListTile(
                  onTap: options[index].onTap,
                  title: Text(options[index].title,
                      style: const TextStyle(fontSize: 18)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
          ],
        ),
      );
    } else {
      widget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Not signed in!",
              style: TextStyle(fontSize: 24),
            ),
            CupertinoButton(
              onPressed: _onLogoutButtonClicked,
              child: const Text(
                "Sign In",
                style: TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      );
    }

    return widget;
  }
}

class _ProfileOption {
  final String title;
  final GestureTapCallback onTap;

  _ProfileOption(this.title, this.onTap);
}
