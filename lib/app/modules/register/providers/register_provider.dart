import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/register_response_model.dart';
import '../../../data/models/register_model.dart';
import '../../../utils/api_constant.dart';

class RegisterProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Register.fromJson(map);
      if (map is List) {
        return map.map((item) => Register.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = API.BASE_URL;
  }

  Future<RegisterResponse> postRegister(Register register) async {
    var result = await post(API.REGISTER_USER, register.toJson());
    debugPrint(result.statusCode.toString());
    debugPrint(result.body.toString());
    RegisterResponse response = RegisterResponse.fromJson(result.body);
    return response;
  }
}
