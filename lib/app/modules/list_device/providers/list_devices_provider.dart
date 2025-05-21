import 'package:disign/app/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/list_devices_model.dart';
import '../../../utils/debug_values.dart';

class ListDevicesProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return ListDevices.fromJson(map);
      if (map is List) {
        return map.map((item) => ListDevices.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = API.BASE_URL;
  }

  Future<ListDevices> getListDevices({String? token}) async {
    final result = await get(API.DEVICES, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
      'Connection': 'keep-alive',
    }).timeout(const Duration(seconds: 3));
    debugPrint(result.statusCode.toString());
    ListDevices listDevices = ListDevices.fromJson(result.body);
    return listDevices;
  }

  Future<Response<ListDevices>> postListDevices(
          ListDevices listdevices) async =>
      await post('listdevices', listdevices);
  Future<Response> deleteListDevices(int id) async =>
      await delete('listdevices/$id');
}
