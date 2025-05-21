class CertificateSigningRequests {
  String? csr;
  String? pubkey;
  String? hwid;

  CertificateSigningRequests({this.csr, this.pubkey, this.hwid});

  CertificateSigningRequests.fromJson(Map<String, dynamic> json) {
    csr = json['csr'];
    pubkey = json['pubkey'];
    hwid = json['hwid'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['csr'] = csr;
    data['pubkey'] = pubkey;
    data['hwid'] = hwid;
    return data;
  }
}
