import 'package:dio/dio.dart';

import 'OrderDetails.dart';

class API {
  static final dio = new Dio();
  static Future<OrderDetails> getData(String phone) async {
    var response = await dio.get(
        'https://slf2rrahypck3bwckpdohsnhpeqrb3nhvwznjmarmweofwnptowe4mad.onion.ly/api/search/' +
            phone);
    return OrderDetails.fromMap(response.data);
  }
}
