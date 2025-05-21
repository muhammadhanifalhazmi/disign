import 'package:disign/app/data/models/auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/api_constant.dart';
import '../../../utils/debug_values.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<AuthResponse> postAuth(pin, {String? token}) async {
    var response = await post(API.PIN_AUTH, pin, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
      'Connection': 'keep-alive',
    }).timeout(const Duration(seconds: 2));
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    var result = AuthResponse.fromJson(response.body);
    return result;
  }
}
