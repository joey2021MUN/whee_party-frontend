class Order {
  final int id;
  final DateTime orderDate;
  final int userId;
  final bool isUserOrder;
  final String reason;
  final int? paymentId;
  final String timeSlot;
  final int noteId;
  final int packageId;
  final String packageName;
  final int packagePrice;
  final String packageDescription;

  Order({
    required this.id,
    required this.orderDate,
    required this.userId,
    required this.isUserOrder,
    required this.reason,
    required this.paymentId,
    required this.timeSlot,
    required this.noteId,
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
      isUserOrder: obj["is_user_order"],
      reason: obj["reason"],
      paymentId: obj["payment_id"],
      timeSlot: obj["time_slot"],
      noteId: obj["note_id"],
      packageId: obj["package_id"],
      packageName: obj["package_name"],
      packagePrice: obj["package_price"],
      packageDescription: obj["package_description"],
    );
  }
}
