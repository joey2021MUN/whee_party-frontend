import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/navigation_model.dart';
import 'package:whee_party/page/login_page.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:whee_party/util/network_util.dart';

import '../model/package.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static bool didTryAutoLogin = false;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Package> _packages = List.empty(growable: true);

  void _refreshPackages() async {
    setState(() {
      _packages.clear();
    });
    var packages = await NetUtil.request("GET", "/package_info");
    // error handling
    if (packages is List) {
      setState(() {
        _packages.addAll(packages.map((p) => Package(
              name: p['name'],
              price: p['price'].toString(),
              description: p['description'],
              backgroundColor: Colors.blue[300],
            )));
      });
    }
  }

  void _tryAutoSignIn() {
    AccountUtil.tryAutoSignIn(context: context, showToast: true, completion: null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshPackages();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future(() {
      _refreshPackages();

      if (!MyHomePage.didTryAutoLogin) {
        _tryAutoSignIn();
        MyHomePage.didTryAutoLogin = true;
      }
    });
  }

  Future<void> onBookPartyClicked() async {
    Provider.of<NavigationModel>(context, listen: false).navigateToPage(1);
  }

  Card makePackage({Color? color, required Package package}) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Text('${package.name}   \$${package.price}+HST',
                  style: const TextStyle(color: Colors.white, fontSize: 20.0)),
              Text(package.description,
                  style: const TextStyle(color: Colors.white, fontSize: 18.0)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ..._packages.map(
                    (p) => makePackage(package: p, color: p.backgroundColor)),
            ElevatedButton(
                onPressed: onBookPartyClicked,
                child: const Text('Book a Party',
                    style: TextStyle(color: Colors.white, fontSize: 20.0)))
          ],
        ),
      ),
    );
  }
}
