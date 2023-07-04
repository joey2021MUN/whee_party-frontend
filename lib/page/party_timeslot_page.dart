import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:whee_party/model/slot_availability.dart';
import 'package:whee_party/util/network_util.dart';
import 'package:whee_party/util/ui_util.dart';
import 'package:whee_party/widget/toggle_button.dart';

class PartyTimeSlotPage extends StatefulWidget {
  final DateTime selectedDate;

  const PartyTimeSlotPage({super.key, required this.selectedDate});

  @override
  State<StatefulWidget> createState() {
    return PartyTimeSlotPageState();
  }
}

class PartyTimeSlotPageState extends State<PartyTimeSlotPage>
    with WidgetsBindingObserver {
  final List<SlotAvailability> _slots = [];

  int _selectedSlotIdentifier = -1;
  bool _isRefreshing = false;

  void _refreshAvailabilities() async {
    setState(() {
      _slots.clear();
      _isRefreshing = true;
    });
    var partyDate = widget.selectedDate.toString();

    try {
      var availabilities = await NetUtil.getSlotAvailabilities(partyDate);
      setState(() {
        _slots.addAll(availabilities);
      });
    } catch (_) {
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshAvailabilities();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }

  void onResume() {
    _refreshAvailabilities();
  }

  void onBookPartyClicked() async {
    UIUtil.showLoadingDialog(context, "Loading...");

    NetUtil.request("POST", "/order", body: {
      "date": widget.selectedDate.toIso8601String(),
      "time_slot_id": _selectedSlotIdentifier
    }).then((value) {
      UIUtil.updateLoadingDialog(context, value["message"]);
      _refreshAvailabilities();
      setState(() {
        _selectedSlotIdentifier = -1;
      });
    }).onError((error, stackTrace) {
      UIUtil.updateLoadingDialog(context, "Network error!");
    });

    Future.delayed(const Duration(seconds: 2), () {
      UIUtil.closeLoadingDialog(context);
    });
    /*
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PaymentRequest()));
     */
  }

  String getSlotDescription(int slotIdentifier) {
    if (slotIdentifier == -1) {
      return "(Not Selected)";
    }
    var slot = _slots.where((s) => s.identifier == slotIdentifier);
    if (slot.isEmpty) {
      return "(Error)";
    }
    return "${slot.first.startTime.format12()} - ${slot.first.endTime.format12()}";
  }

  List<Widget> formatDate(DateTime dateTime) {
    return [
      Text(
        DateFormat("EEEE").format(dateTime),
        style: const TextStyle(color: Colors.white, fontSize: 25.0),
      ),
      Text(
        DateFormat("yyyy-MM-dd").format(dateTime),
        style: const TextStyle(color: Colors.white, fontSize: 25.0),
      ),
      Text(
        "Slot: ${getSlotDescription(_selectedSlotIdentifier)}",
        style: const TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var refreshingWidget = Center(
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(5.0),
        child: const CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.lightBlue,
        ),
      ),
    );

    var gridChildren = _slots
        .map((slot) => ToggleButton(
            isOn: slot.identifier == _selectedSlotIdentifier,
            isEnabled: slot.available,
            normalColor: const Color.fromARGB(255, 235, 235, 235),
            disabledColor: Colors.white12,
            selectedColor: Colors.lightGreen,
            onPress: () {
              setState(() {
                _selectedSlotIdentifier = slot.identifier;
              });
            },
            child: Container(
              height: 20,
              alignment: Alignment.center,
              child: Text(
                getSlotDescription(slot.identifier),
                style: TextStyle(color: slot.available ? Colors.black : Colors.grey),
              ),
            )))
        .toList();

    var normalWidget = Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.lightBlueAccent,
              margin: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 50.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: formatDate(widget.selectedDate),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4,
                crossAxisSpacing: 0,
                controller: ScrollController(keepScrollOffset: false),
                children: gridChildren,
              ),
            ),
            FilledButton(
              onPressed:
              _selectedSlotIdentifier == -1 ? null : onBookPartyClicked,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(140, 40),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("Book"),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Time Slot'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: _isRefreshing ? refreshingWidget : normalWidget,
    );
  }
}
