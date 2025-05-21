import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/api_constant.dart';
import '../../../utils/debug_values.dart';

class LogoutProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'YOUR-API-URL';
  }
  Future<Response> postLogout(String? token) async {
    var response = await post(
      API.LOGOUT, null, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
      'Connection': 'keep-alive',
    }).timeout(const Duration(seconds: 2));
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    return response;
  }
}
