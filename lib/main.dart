import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/page/home_page.dart';
import 'package:whee_party/page/party_date_page.dart';
import 'package:whee_party/page/profile_page.dart';
import 'package:whee_party/page/router_page.dart';
import 'model/navigation_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AccountModel(),
      child: ChangeNotifierProvider(
        create: (_) => NavigationModel(),
        child: const WheeParty(),
      ),
    ),
  );
}

class WheeParty extends StatelessWidget {
  final widgets = const [
    WidgetItem(
      label: "Home",
      title: "Whee Indoor Playground",
      icon: Icon(Icons.home),
      widget: MyHomePage(),
    ),
    WidgetItem(
      label: "Party",
      title: "Select a Date",
      icon: Icon(Icons.celebration),
      widget: PartyDatePage(),
    ),
    WidgetItem(
      label: "Profile",
      title: "Profile",
      icon: Icon(Icons.person_pin),
      widget: ProfilePage(),
    ),
  ];

  const WheeParty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whee Indoor Playground',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RouterPage(widgetItems: widgets),
    );
  }
}
