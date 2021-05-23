import 'dart:convert';

OrderDetails orderDetailsFromMap(String str) =>
    OrderDetails.fromMap(json.decode(str));

String orderDetailsToMap(OrderDetails data) => json.encode(data.toMap());

class OrderDetails {
  OrderDetails({
    required this.searchStr,
    required this.wallTime,
    required this.dbData,
  });

  final String searchStr;
  final double wallTime;
  final DbData dbData;

  factory OrderDetails.fromMap(Map<String, dynamic> json) => OrderDetails(
        searchStr: json["search_str"],
        wallTime: json["wall_time"].toDouble(),
        dbData: DbData.fromMap(json["db_data"]),
      );

  Map<String, dynamic> toMap() => {
        "search_str": searchStr,
        "wall_time": wallTime,
        "db_data": dbData.toMap(),
      };
}

class DbData {
  DbData({
    required this.linkedMobiles,
    required this.linkedEmails,
    required this.totalNumOrders,
    required this.totalPriceSpent,
    required this.randomOrders,
    required this.otherDetails,
  });

  final List<String> linkedMobiles;
  final List<String> linkedEmails;
  final int totalNumOrders;
  final int totalPriceSpent;
  final List<RandomOrder> randomOrders;
  final List<String> otherDetails;

  factory DbData.fromMap(Map<String, dynamic> json) => DbData(
        linkedMobiles: List<String>.from(json["linked_mobiles"].map((x) => x)),
        linkedEmails: List<String>.from(json["linked_emails"].map((x) => x)),
        totalNumOrders: json["total_num_orders"],
        totalPriceSpent: json["total_price_spent"],
        randomOrders: List<RandomOrder>.from(
            json["random_orders"].map((x) => RandomOrder.fromMap(x))),
        otherDetails: List<String>.from(json["other_details"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "linked_mobiles": List<dynamic>.from(linkedMobiles.map((x) => x)),
        "linked_emails": List<dynamic>.from(linkedEmails.map((x) => x)),
        "total_num_orders": totalNumOrders,
        "total_price_spent": totalPriceSpent,
        "random_orders": List<dynamic>.from(randomOrders.map((x) => x.toMap())),
        "other_details": List<dynamic>.from(otherDetails.map((x) => x)),
      };
}

class RandomOrder {
  RandomOrder({
    required this.deliveryAddress,
    required this.deliveryAddressLatLon,
    required this.deliveryMobileNo,
    required this.orderPrice,
    required this.orderTimeGmt,
  });

  final String deliveryAddress;
  final List<double> deliveryAddressLatLon;
  final String deliveryMobileNo;
  final int orderPrice;
  final DateTime orderTimeGmt;

  factory RandomOrder.fromMap(Map<String, dynamic> json) => RandomOrder(
        deliveryAddress: json["delivery_address"],
        deliveryAddressLatLon: List<double>.from(
            json["delivery_address_lat_lon"].map((x) => x.toDouble())),
        deliveryMobileNo: json["delivery_mobile_no"],
        orderPrice: json["order_price"],
        orderTimeGmt: DateTime.parse(json["order_time_gmt"]),
      );

  Map<String, dynamic> toMap() => {
        "delivery_address": deliveryAddress,
        "delivery_address_lat_lon":
            List<dynamic>.from(deliveryAddressLatLon.map((x) => x)),
        "delivery_mobile_no": deliveryMobileNo,
        "order_price": orderPrice,
        "order_time_gmt": orderTimeGmt.toIso8601String(),
      };
}
