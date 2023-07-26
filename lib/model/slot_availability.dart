import 'package:whee_party/model/time.dart';

class SlotAvailability {
  final int identifier;
  final Time startTime;
  final Time endTime;
  final bool available;
  final String? reason;

  SlotAvailability({
    required this.identifier,
    required this.startTime,
    required this.endTime,
    required this.available,
    required this.reason,
  });

  static SlotAvailability fromJson(dynamic obj) {
    return SlotAvailability(
      identifier: obj["id"],
      startTime: Time.parse(obj["start_time"])!,
      endTime: Time.parse(obj["end_time"])!,
      available: obj["available"],
      reason: obj["reason"],
    );
  }
}
