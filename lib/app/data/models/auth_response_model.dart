class AuthResponse {
  bool? isValid;
  String? message;

  AuthResponse({this.isValid, this.message});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    isValid = json['isValid'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isValid'] = isValid;
    data['message'] = message;
    return data;
  }
}
