class Time {
  int hour = 0;
  int minute = 0;
  int second = 0;

  Time(this.hour, this.minute, this.second);

  /// Accept only 24-hour format.
  /// "12:00:00" => hour=12, minute=0, second=0
  /// @return Time if success, null if failed
  static Time? parse(String s) {
    try {
      var parts = s.split(":");
      var hour = int.parse(parts[0]);
      var minute = int.parse(parts[1]);
      var second = int.parse(parts[2]);
      return Time(hour, minute, second);
    }
    catch (_) {
      return null;
    }
  }

  int totalSeconds() {
    return hour * 3600 + minute * 60 + second;
  }

  String format24() {
    var hourString = hour < 10 ? "0$hour" : hour.toString();
    var minuteString = minute < 10 ? "0$minute" : minute.toString();
    var secondString = second < 10 ? "0$second" : second.toString();
    return "$hourString:$minuteString:$secondString";
  }

  String format12() {
    var suffix = hour > 12 ? "PM" : "AM";
    var hour12 = hour > 12 ? hour - 12 : hour;
    var hourString = hour12 < 10 ? "0$hour12" : hour12.toString();
    var minuteString = minute < 10 ? "0$minute" : minute.toString();
    return "$hourString:$minuteString $suffix";
  }

  bool operator >(Time other) {
    return totalSeconds() > other.totalSeconds();
  }

  bool operator <(Time other) {
    return totalSeconds() < other.totalSeconds();
  }

  @override
  bool operator ==(other) {
    return (other is Time) && other.totalSeconds() == totalSeconds();
  }

  @override
  int get hashCode => (hour + minute + second).hashCode;

}
