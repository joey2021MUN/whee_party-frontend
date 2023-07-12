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
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  bool didUserSelectedDay = false;

  void onNextClicked() {
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
    if (selectedDay.isAfter(DateTime.now())) {
      setState(() {
        didUserSelectedDay = true;
        selectedDate = selectedDay;
      });
    }
  }

  bool isSameDay(DateTime x, DateTime y) {
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }

  bool isBefore(DateTime x, DateTime y) {
    return !x.isAfter(y);
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
            // weekends after current date are highlighted with red color.
            calendarBuilders: CalendarBuilders(
              holidayBuilder: (context, day, _) {
                return Center(
                    child: Text(
                  day.day.toString(),
                  style: TextStyle(
                      color: day.isAfter(DateTime.now())
                          ? Colors.red
                          : Colors.grey),
                ));
              },
              // all dates before current date are grey and disabled.
              defaultBuilder: (context, day, _) {
                return Center(
                    child: day.isAfter(DateTime.now())
                        ? Text(day.day.toString())
                        : Text(
                            day.day.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ));
              },
            ),
            selectedDayPredicate: (day) {
              return didUserSelectedDay && isSameDay(selectedDate, day);
            },
            onDaySelected: onDaySelected,
          ),
          ElevatedButton(
              onPressed: didUserSelectedDay ? onNextClicked : null,
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 20.0),
              ))
        ],
      ),
    );
  }
}
