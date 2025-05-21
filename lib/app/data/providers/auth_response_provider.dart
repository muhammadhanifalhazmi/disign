import 'package:get/get.dart';

import '../models/auth_response_model.dart';

class AuthResponseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return AuthResponse.fromJson(map);
      if (map is List) {
        return map.map((item) => AuthResponse.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<AuthResponse?> getAuthResponse(int id) async {
    final response = await get('authresponse/$id');
    return response.body;
  }

  Future<Response<AuthResponse>> postAuthResponse(
          AuthResponse authresponse) async =>
      await post('authresponse', authresponse);
  Future<Response> deleteAuthResponse(int id) async =>
      await delete('authresponse/$id');
}
