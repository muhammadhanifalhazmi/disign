class LoginResponse {
  Device? device;
  String? token;
  String? message;

  LoginResponse({this.device, this.token, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    device =
        json['device'] != null ? Device.fromJson(json['device']) : null;
    token =  json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (device != null) {
      data['device'] = device!.toJson();
    }
    data['token'] = token;
    data['message'] = message;
    return data;
  }
}

class Device {
  String? message;
  String? lastActive;

  Device({this.message, this.lastActive});

  Device.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    lastActive = json['last_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['last_active'] = lastActive;
    return data;
  }
}
