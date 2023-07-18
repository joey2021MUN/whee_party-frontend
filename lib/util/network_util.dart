import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whee_party/model/account_model.dart';
import 'package:whee_party/util/account_util.dart';
import 'package:http/src/response.dart';

import '../model/slot_availability.dart';
import '../model/order.dart';
import '../model/user.dart';

class NetUtil {
  //static const String host = "192.168.2.27"; // home
  static String host = "10.20.241.168"; // school

  static Future<dynamic> request(String method, String path,
   { Map<String, dynamic>? body, bool needAuthentication = false }) async {
    var url = Uri.parse('http://$host:3000$path');

    // Await the http get response, then decode the json-formatted response.
    http.Response response;
    var headers = {"Content-Type": "application/json"};

    if (needAuthentication) {
      var token = AccountModel.currentSessionToken
          ?? await AccountUtil.getStoredToken();
      headers["Authorization"] = "Bearer $token" ?? "";
    }

    /// TODO
    if (method.trim().toLowerCase() == "post") {
      response = await http.post(url,
          headers: headers,
          body: json.encode(body));
    }
    else if (method.trim().toLowerCase() == "put") {
      response = await http.put(url,
          headers: headers,
          body: json.encode(body));
    }
    else if (method.trim().toLowerCase() == "delete") {
      response = await http.delete(url, headers: headers);
    }
    else {
      // default to GET
      response = await http.get(url, headers: headers);
    }

    if (response.statusCode == 200) {
      return Future.value(json.decode(response.body));
    } else {
      return Future.error(response.statusCode);
    }
  }

  static Future<List<SlotAvailability>> getSlotAvailabilities(String partyDate) async {
    try {
      var slots = await NetUtil.request(
          "GET", "/check-slot-availability?partyDate=$partyDate");
      List<SlotAvailability> ret = [];
      for (var slot in slots) {
        ret.add(SlotAvailability.fromJson(slot));
      }
      return Future.value(ret);
    }
    catch(e) {
      return Future.error(e);
    }
  }

  static Future<List<Order>> getOrderHistory() async {
    try {
      var response = await NetUtil.request(
          "GET", "/order", needAuthentication: true);
      if (!response["success"]) {
        return Future.error(response["message"]);
      }
      List<Order> ret = [];
      
      for (var order in response["orders"]) {
        ret.add(Order.fromJson(order));
      }
      return Future.value(ret);
    }
    catch(e) {
      return Future.error(e);
    }
  }

  static Future<String> deleteOrder(int orderId) async {
    var response = await NetUtil.request(
        "DELETE", "/order/$orderId", needAuthentication: true);
    return Future.value(response["message"]);
  }

  static Future<String> updateSelfUser(User user) async {
    var response = await NetUtil.request(
        "PUT", "/user", body: user.toMap(), needAuthentication: true);
    return Future.value(response["message"]);
  }
}
