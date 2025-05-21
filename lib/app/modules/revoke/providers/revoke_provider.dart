import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/revoke_response_model.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/debug_values.dart';

class RevokeProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return RevokeResponse.fromJson(map);
      if (map is List) {
        return map.map((item) => RevokeResponse.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = API.BASE_URL;
  }

  // Future<RevokeResponse> postRevoke(revoke, {String? token}) async {
  //   var response = await post(API.REQUEST_REVOKE, revoke, headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
  //     'Connection': 'keep-alive',
  //   }).timeout(Duration(seconds: 2));
  //   debugPrint(response.statusCode.toString());
  //   debugPrint(response.body.toString());
  //   RevokeResponse result = RevokeResponse.fromJson(response.body);
  //   // response.body.
  //   return result;
  // }

  Future<RevokeResponse> postRevoke(revoke, {String? token}) async {
    var response = await post(API.REQUEST_REVOKE, revoke, headers: {
      // 'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
      'Connection': 'keep-alive',
    }).timeout(const Duration(seconds: 2));
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    RevokeResponse result = RevokeResponse.fromJson(response.body);
    // response.body.
    return result;
  }

}
