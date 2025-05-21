// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/models/csr_model.dart';
import '../../../data/models/certificate_model.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/debug_values.dart';

class CertificateProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CsrResponse.fromJson(map);
      if (map is List)
        // ignore: curly_braces_in_flow_control_structures
        return map.map((item) => CsrResponse.fromJson(item)).toList();
    };
    httpClient.baseUrl = API.BASE_URL;
  }

  Future<CsrResponse?> getCertificate(int id) async {
    final response = await get('certificate/$id');
    return response.body;
  }

  Future<CsrResponse> postCertificate(CertificateSigningRequests csr,
      {String? token}) async {
    final response = await post(API.CSR, csr.toJson(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? DEBUG.TOKEN}',
      'Connection': 'keep-alive',
    } ).timeout(const Duration(seconds: 3));
    // debugPrint("STATUS " + response.statusCode.toString() + " : " + response.statusText.toString());
    // debugPrint("BODY :"+ response.body.toString());
    CsrResponse certificate = CsrResponse.fromJson(response.body);
    return certificate;
  }

  Future<Response> deleteCertificate(int id) async =>
      await delete('certificate/$id');
}
