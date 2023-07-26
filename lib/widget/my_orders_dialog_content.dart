import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whee_party/model/order.dart';
import 'package:whee_party/util/network_util.dart';
import 'package:whee_party/util/dialog_util.dart';
import 'package:whee_party/model/payment_status.dart';

class MyOrdersDialogContent extends StatefulWidget {
  @override
  MyOrdersDialogContentState createState() => MyOrdersDialogContentState();
}

class MyOrdersDialogContentState extends State<MyOrdersDialogContent> {
  List<Order> orders = [];
  bool loading = true;

  void onPay(Order order) {}

  void onCancel(Order order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "You are trying to delete order\n\n${order.summary()}\n\nAre you sure?"),
            (order.paymentStatus == PaymentStatus.fullyPaid ||
                    order.paymentStatus == PaymentStatus.partiallyPaid)
                ? const Text(
                    "The order is already paid. There will be no refund",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(""),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Dont' Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Cancel Order!",
                style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();

              NetUtil.cancelOrder(order.id).then((response) {
                DialogUtil.alertDialog(context, response);
                refreshOrders();
              });
            },
          ),
        ],
      ),
    );
  }

  void refreshOrders() {
    setState(() {
      loading = true;
      orders.clear();
    });
    NetUtil.getOrderHistory().then((List<Order> orders) {
      setState(() {
        loading = false;
        this.orders.addAll(orders);
      });
    }).catchError((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    const loadingView = Center(child: CircularProgressIndicator());
    var normalView = ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      itemBuilder: (_, int index) {
        var order = orders[index];
        var shouldShowPay = !order.cancelled &&
            order.paymentStatus != PaymentStatus.packageNotSelected &&
            order.paymentStatus != PaymentStatus.fullyPaid;

        var shouldShowCancel = !order.cancelled;

        var shouldShowSelectPackage = !order.cancelled &&
            order.paymentStatus == PaymentStatus.packageNotSelected;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "Order #${order.id}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              subtitle: Text(
                order.orderDate.toString().split(" ")[0],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              trailing: Text(order.cancelled
                  ? "Cancelled"
                  : order.paymentStatus.description),
            ),
            Card(
              elevation: 0,
              color: Colors.black12,
              child: Container(
                padding: const EdgeInsets.all(8),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${order.packageName} (\$${order.packagePrice})"),
                    Text("Time Slot: ${order.timeSlot}"),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                shouldShowPay
                    ? CupertinoButton(
                        child: const Text("Pay"), onPressed: () => onPay(order))
                    : Container(),
                shouldShowCancel
                    ? CupertinoButton(
                        child: const Text("Cancel"),
                        onPressed: () => onCancel(order))
                    : Container(),
                shouldShowSelectPackage
                    ? CupertinoButton(
                        child: const Text("Select Package"),
                        onPressed: () => {})
                    : Container(),
              ],
            ),
            const Divider(thickness: 3),
          ],
        );
      },
    );

    return SizedBox(
      width: double.maxFinite,
      child: loading ? loadingView : normalView,
    );
  }
}
