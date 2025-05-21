import 'package:get/get.dart';

import '../models/revoke_response_model.dart';

class RevokeResponseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return RevokeResponse.fromJson(map);
      if (map is List) {
        return map.map((item) => RevokeResponse.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<RevokeResponse?> getRevokeResponse(int id) async {
    final response = await get('revokeresponse/$id');
    return response.body;
  }

  Future<Response<RevokeResponse>> postRevokeResponse(
          RevokeResponse revokeresponse) async =>
      await post('revokeresponse', revokeresponse);
  Future<Response> deleteRevokeResponse(int id) async =>
      await delete('revokeresponse/$id');
}
