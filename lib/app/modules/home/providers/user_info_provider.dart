import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_info_model.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/debug_values.dart';

class UserInfoProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return UserInfo.fromJson(map);
      if (map is List) {
        return map.map((item) => UserInfo.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = API.BASE_URL;
  }

  Future<UserInfo?> getUser(String hwid, {String? token}) async {
    final result = await get(API.USER_DETAILS + hwid, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
      'Connection': 'keep-alive',
    }).timeout(const Duration(seconds: 3));
    debugPrint(result.statusCode.toString());
    debugPrint(result.body.toString());
    UserInfo user = UserInfo.fromJson(result.body);
    return user;
  }
}
