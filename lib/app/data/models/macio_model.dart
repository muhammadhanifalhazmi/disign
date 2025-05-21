class Macio {
  String? username;
  String? name;
  String? email;
  String? password;
  String? pin;
  String? hwid;
  String? deviceName;

  Macio(
      {this.username,
      this.name,
      this.email,
      this.password,
      this.pin,
      this.hwid,
      this.deviceName});

  Macio.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    pin = json['pin'];
    hwid = json['hwid'];
    deviceName = json['device_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['pin'] = pin;
    data['hwid'] = hwid;
    data['device_name'] = deviceName;
    return data;
  }
}
