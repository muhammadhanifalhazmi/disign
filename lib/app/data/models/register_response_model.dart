class RegisterResponse {
  String? token;
  String? message;

  RegisterResponse({this.token, this.message});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['message'] = message;
    return data;
  }
}