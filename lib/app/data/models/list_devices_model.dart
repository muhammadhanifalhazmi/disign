import 'user_info_model.dart';

class ListDevices {
  List<Devices>? devices;

  ListDevices({this.devices});

  ListDevices.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = <Devices>[];
      json['devices'].forEach((v) {
        devices?.add(Devices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (devices != null) {
      data['devices'] = devices?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Devices {
  int? id;
  int? userId;
  String? hwid;
  String? deviceName;
  String? lastActive;
  String? createdAt;
  String? updatedAt;
  Certificate? activeCertificate;
  Certificate? lastCertificate;

  Devices(
      {this.id,
      this.userId,
      this.hwid,
      this.deviceName,
      this.lastActive,
      this.createdAt,
      this.updatedAt,
      this.activeCertificate,
      this.lastCertificate});

  Devices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    hwid = json['hwid'];
    deviceName = json['device_name'];
    lastActive = json['last_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    activeCertificate = json['active_certificate'] != null
        ? Certificate.fromJson(json['active_certificate'])
        : null;
    lastCertificate = json['last_certificate'] != null
        ?  Certificate.fromJson(json['last_certificate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['hwid'] = hwid;
    data['device_name'] = deviceName;
    data['last_active'] = lastActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (activeCertificate != null) {
      data['active_certificate'] = activeCertificate!.toJson();
    }
    if (lastCertificate != null) {
      data['last_certificate'] = lastCertificate!.toJson();
    }
    return data;
  }
}
