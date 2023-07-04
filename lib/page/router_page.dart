import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whee_party/model/navigation_model.dart';

class WidgetItem {
  final Widget widget;
  final String title;
  final String label;
  final Icon icon;

  const WidgetItem({
    required this.label,
    required this.title,
    required this.icon,
    required this.widget,
  });
}

class RouterPage extends StatefulWidget {
  final List<WidgetItem> widgetItems;

  const RouterPage({required this.widgetItems, super.key});

  @override
  State createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  void _onItemTapped(int newIndex) {
    Provider.of<NavigationModel>(context, listen: false).navigateToPage(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<NavigationModel>(context).currentNavigationIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.widgetItems[currentIndex].title),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: widget.widgetItems
            .map((item) =>
                BottomNavigationBarItem(icon: item.icon, label: item.label))
            .toList(),
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: widget.widgetItems[currentIndex].widget,
      ),
    );
  }
}
