import 'package:get/get.dart';

import '../models/macio_model.dart';

class MacioProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Macio.fromJson(map);
      if (map is List) return map.map((item) => Macio.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Macio?> getMacio(int id) async {
    final response = await get('macio/$id');
    return response.body;
  }

  Future<Response<Macio>> postMacio(Macio macio) async =>
      await post('macio', macio);
  Future<Response> deleteMacio(int id) async => await delete('macio/$id');
}
