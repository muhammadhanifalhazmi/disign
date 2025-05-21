class Register {
  String? username;
  String? name;
  // ignore: non_constant_identifier_names
  String? location_info;
  String? email;
  String? password;
  String? pin;
  String? hwid;
  String? deviceName;

  Register(
      {this.username,
      this.name,
      this.location_info,
      this.email,
      this.password,
      this.pin,
      this.hwid,
      this.deviceName});

  Register.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    location_info = json['location_info'];
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
    data['location_info'] = location_info;
    data['email'] = email;
    data['password'] = password;
    data['pin'] = pin;
    data['hwid'] = hwid;
    data['device_name'] = deviceName;
    return data;
  }
}
