import 'dart:developer';

import 'package:cashback_app/commons/auth_token.dart';
import 'package:cashback_app/helper/api_requester.dart';
import 'package:cashback_app/helper/catchException.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SignInProvider {
  Future loginUser({
    required String phone,
    required String password,
  }) async {
    try {
      ApiRequester requester = ApiRequester();
      Response response =
          await requester.toPost('/auth/token/token/login/', body: {
        'password': password,
        'phone': phone,
      });
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        log(response.data.toString());
        var box = Hive.box('tokenBox');
        box.put('token', 'Token ${response.data['auth_token']}');
        print(box.get('token'));
        print('sikdjcnsdjk==============${AuthToken.token}');
      } else {
        print("!");
        throw CatchException.convertException(response);
      }
    } catch (e) {
      print(e);
      throw CatchException.convertException(e);
    }
  }
}