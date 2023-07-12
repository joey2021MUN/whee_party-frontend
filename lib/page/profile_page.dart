import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/page/login_page.dart';
import 'package:whee_party/util/account_util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AccountModel? state;

  void _onLogoutButtonClicked() {
    if (state?.isSignedIn ?? false) {
      AccountUtil.signOut(context);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AccountModel>(context, listen: true);

    var signedInView = Column(
      children: [
        Text(
          "Already signed in as ${state!.loggingFullName}",
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          "Email: ${state!.loggingInEmail}",
          style: const TextStyle(fontSize: 24),
        )
      ],
    );

    return Center(
      child: Column(
        children: [
          state!.isSignedIn
              ? signedInView
              : const Text(
                  "Not signed in!",
                  style: TextStyle(fontSize: 24),
                ),
          CupertinoButton(
            onPressed: _onLogoutButtonClicked,
            child: state!.isSignedIn
                ? const Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 24),
                  )
                : const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 24),
                  ),
          )
        ],
      ),
    );
  }
}
