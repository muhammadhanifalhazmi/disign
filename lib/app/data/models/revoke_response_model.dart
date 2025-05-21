class RevokeResponse {
  int? revocationStatus;
  String? message;
  String? fileUpload;

  RevokeResponse({this.revocationStatus, this.message, this.fileUpload});

  RevokeResponse.fromJson(Map<String, dynamic> json) {
    revocationStatus = json['revocation_status'];
    message = json['message'];
    fileUpload = json['file_upload'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['revocation_status'] = revocationStatus;
    data['message'] = message;
    data['file_upload'] = fileUpload;
    return data;
  }
}
