import 'login_response_model.dart';

class RegisterDeviceResponse {
  Device? device;
  String? message;

  RegisterDeviceResponse({this.device, this.message});

  RegisterDeviceResponse.fromJson(Map<String, dynamic> json) {
    device = json['device'] != null ? Device?.fromJson(json['device']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (device != null) {
      data['device'] = device?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

// class Device {
//   int? userId;
//   String? hwid;
//   String? deviceName;
//   String? lastActive;
//   String? updatedAt;
//   String? createdAt;
//   int? id;

//   Device(
//       {this.userId,
//       this.hwid,
//       this.deviceName,
//       this.lastActive,
//       this.updatedAt,
//       this.createdAt,
//       this.id});

//   Device.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     hwid = json['hwid'];
//     deviceName = json['device_name'];
//     lastActive = json['last_active'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     id = json['id'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['user_id'] = userId;
//     data['hwid'] = hwid;
//     data['device_name'] = deviceName;
//     data['last_active'] = lastActive;
//     data['updated_at'] = updatedAt;
//     data['created_at'] = createdAt;
//     data['id'] = id;
//     return data;
//   }
// }
