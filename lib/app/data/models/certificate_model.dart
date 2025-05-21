class CsrResponse {
  String? userCertificate;
  String? certificateChain;

  CsrResponse({this.userCertificate, this.certificateChain});

  CsrResponse.fromJson(Map<String, dynamic> json) {
    userCertificate = json['user_certificate'];
    certificateChain = json['certificate_chain'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_certificate'] = userCertificate;
    data['certificate_chain'] = certificateChain;
    return data;
  }
}
