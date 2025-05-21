import 'package:get/get.dart';

import '../../../data/models/register_device_response_model.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/debug_values.dart';

class RegisterDeviceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) {
        return RegisterDeviceResponse.fromJson(map);
      }
      if (map is List) {
        return map
            .map((item) => RegisterDeviceResponse.fromJson(item))
            .toList();
      }
    };
    httpClient.baseUrl = API.REGISTER_DEVICE;
  }

  Future<RegisterDeviceResponse> postRegisterDevice(
      request, {String? token}) async {
    var response = await post(API.REGISTER_DEVICE, request, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
      'Connection': 'keep-alive',
    }).timeout(const Duration(seconds: 3));
    RegisterDeviceResponse result = RegisterDeviceResponse.fromJson(response.body);
    return result;
  }

  Future<Response> deleteRegisterDeviceResponse(int id) async =>
      await delete('registerdeviceresponse/$id');
}
