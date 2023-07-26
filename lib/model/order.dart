import 'package:whee_party/model/payment_status.dart';

class Order {
  final int id;
  final DateTime orderDate;
  final int userId;
  final bool cancelled;
  final String reason;
  final String timeSlot;
  final PaymentStatus paymentStatus;
  final int orderInfoId;
  final int packageId;
  final String packageName;
  final int packagePrice;
  final String packageDescription;

  Order({
    required this.id,
    required this.orderDate,
    required this.userId,
    required this.cancelled,
    required this.reason,
    required this.timeSlot,
    required this.paymentStatus,
    required this.orderInfoId,
    required this.packageId,
    required this.packageName,
    required this.packagePrice,
    required this.packageDescription,
  });

  static Order fromJson(dynamic obj) {
    return Order(
      id: obj["id"],
      orderDate: DateTime.parse(obj["order_date"]),
      userId: obj["user_id"],
      cancelled: obj["cancelled"],
      reason: obj["reason"],
      timeSlot: obj["time_slot"],
      paymentStatus: PaymentStatus.fromRawValue(obj["payment_status"]),
      orderInfoId: obj["order_info_id"],
      packageId: obj["package_id"],
      packageName: obj["package_name"],
      packagePrice: obj["package_price"],
      packageDescription: obj["package_description"],
    );
  }

  String summary() {
    return "Order Date: $orderDate\nTime Slot: $timeSlot\nPackage: $packageName\nPackage Price: $packagePrice\nPackage Description: $packageDescription";
  }
}
