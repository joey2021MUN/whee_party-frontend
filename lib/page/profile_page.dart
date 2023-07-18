import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/model/order.dart';
import 'package:whee_party/page/login_page.dart';
import 'package:whee_party/page/edit_profile_widget.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:whee_party/util/network_util.dart';

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

  void onPay(Order order) {

  }

  void onCancel(Order order) {
    NetUtil.deleteOrder(order.id);
  }

  void onMyOrders() {
    NetUtil.getOrderHistory().then((List<Order> orders) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("My Orders"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (_, int index) {
                var order = orders[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("Order #${order.id}"),
                      subtitle: Text(order.orderDate.toString().split(" ")[0]),
                      trailing:
                          Text(order.paymentId != null ? "Paid" : "Not Paid"),
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.black12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${order.packageName} (\$${order.packagePrice})"),
                            Text("Time Slot: ${order.timeSlot}"),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                    CupertinoButton(child: const Text("Pay"), onPressed: () => onPay(order)),
                    CupertinoButton(child: const Text("Cancel"), onPressed: () => onCancel(order)),

                      ],
                    ),
                    const Divider(thickness: 3),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AccountModel>(context, listen: true);
    late Widget widget;

    if (state.isSignedIn) {
      var user = state.currentUser!;
      var options = <_ProfileOption>[
        _ProfileOption("My Orders", onMyOrders),
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
                  const Text("Avatar"),
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
