import 'package:disign/app/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/login_response_model.dart';
import '../../../data/models/login_model.dart';

class LoginProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Login.fromJson(map);
      if (map is List) return map.map((item) => Login.fromJson(item)).toList();
    };
    httpClient.baseUrl = API.BASE_URL;
  }

  Future<void> getLogin() async {
    // final response = await get('${API.LOGIN}/$id');
    final response = await get(API.TEST);
    debugPrint(response.body.toString());
    debugPrint(response.statusCode.toString());
    return response.body;
  }

  Future<LoginResponse> postLogin(Login login) async {
    var response = await post(API.LOGIN, login.toJson(),);
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    LoginResponse loginResponse = LoginResponse.fromJson(response.body);
    return loginResponse; 
  }

  Future<Response> deleteLogin(int id) async => await delete('login/$id');
}
