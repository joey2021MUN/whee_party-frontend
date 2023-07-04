import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:whee_party/page/party_timeslot_page.dart';

class PartyDatePage extends StatefulWidget {
  const PartyDatePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return PartyDatePageState();
  }
}

class PartyDatePageState extends State<PartyDatePage> {
  DateTime selectedDate = DateTime.now();

  void onTimeSlotClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartyTimeSlotPage(
          selectedDate: selectedDate,
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    var now = DateTime.now();
    if (isBefore(selectedDay, now)) {
      // Same day is still allowed to select.
      if (!isSameDay(selectedDay, now)) {
        return;
      }
    }
    setState(() {
      selectedDate = selectedDay;
    });
  }

  bool isSameDay(DateTime x, DateTime y) {
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }

  bool isBefore(DateTime x, DateTime y) {
    return x.isBefore(y);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TableCalendar(
            locale: "en_US",
            focusedDay: selectedDate,
            firstDay: DateTime.utc(2019, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            holidayPredicate: (day) {
              return day.weekday == DateTime.sunday ||
                  day.weekday == DateTime.saturday;
            },
            calendarBuilders: CalendarBuilders(
              holidayBuilder: (context, day, _) {
                return Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: isBefore(day, DateTime.now())
                            ? Colors.grey
                            : Colors.red,
                      ),
                    ));
              },
              defaultBuilder: (context, day, _) {
                return Center(
                  child: isBefore(day, DateTime.now())
                      ? Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )
                      : Text(day.day.toString()),
                );
              },
            ),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: onDaySelected,
          ),
          ElevatedButton(
              onPressed: onTimeSlotClicked,
              child: const Text(
                'select a time slot',
                style: TextStyle(fontSize: 20.0),
              ))
        ],
      ),
    );
  }
}
