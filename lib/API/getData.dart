import 'package:dio/dio.dart';

import 'OrderDetails.dart';

class API {
  static final dio = new Dio(BaseOptions());
  static Future<OrderDetails> getData(String phone) async {
    if (phone.length > 10)
      for (int i = 0; i < 10; i++) {
        try {
          print('Request $i Query $phone');
          var response = await dio.get(
              'https://slf2rrahypck3bwckpdohsnhpeqrb3nhvwznjmarmweofwnptowe4mad.onion.ly/api/search/' +
                  phone);
          return orderDetailsFromMap(response.toString());
        } catch (e) {
          await Future.delayed(const Duration(seconds: 1));
        }
      }

    var response = await dio.get(
        'https://slf2rrahypck3bwckpdohsnhpeqrb3nhvwznjmarmweofwnptowe4mad.onion.ly/api/search/' +
            phone);
    return orderDetailsFromMap(response.toString());
  }
}
